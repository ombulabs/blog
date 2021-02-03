---
layout: post
title: "Behind The Scenes: Devise"
date: 2021-02-04 14:00:00
categories: ["learning", "devise"]
author: arieljuod
---

[**Devise**](https://github.com/heartcombo/devise) is a well known solution for authentication in **Rails** applications. It's full featured (it not only adds authentication but also password recovery, email changing, session timeout, locking, ip tracking, etc.) and can be expanded to add even more (like JWT authentication).

In this post, I'll go over the code related to the basic database authentication process, how it relates to [**Warden**](https://github.com/wardencommunity/warden) and some of the magic behind it. If you don't know what Warden is, I will be explaining the roll it plays for Devise in this article.

<!--more-->

## Gem Initialization Process

Like most gems, when loaded, the entry point is `lib/devise.rb` ([link](https://github.com/heartcombo/devise/blob/master/lib/devise.rb)). Inside this file we can find a lot of code:
- it requires many modules (like `rails`, `activesupport`, etc)
- then it defines the Devise module which does many things:
  - autoloads many modules for Controllers, Mailers, Tests, Strategies (we'll get back to this later)
  - defines all the module's attribute accessors for configuration
  - defines methods for extending devise
  - and more
- at the end it requires `warden` and Devise's extensions for `models`, `rails`, etc

If we take a look the the files in the last part of the `lib/devise.rb` file, we can better understand how it works.

At `lib/devise/rails.rb`, we can see Devise runs as a Rails Engine and it adds Warden as a middleware:

```ruby
# Initialize Warden and copy its configurations.
config.app_middleware.use Warden::Manager do |config|
  Devise.warden_config = config
end
```

At `lib/devise/models.rb`, we can see it defines the Device::Models module which is later included in ActiveRecord::Base and adds the `devise` helper method used to configure our authenticable ActiveRecord models:

```ruby
module Devise
  module Models
    def devise(*modules)
      options = modules.extract_options!.dup

      selected_modules = modules.map(&:to_sym).uniq.sort_by do |s|
        Devise::ALL.index(s) || -1  # follow Devise::ALL order
      end

      ...
```

```ruby
# lib/devise/orm/active_record.rb

require 'orm_adapter/adapters/active_record'

ActiveSupport.on_load(:active_record) do
  extend Devise::Models
end
```

And we can use it like:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
```

## What's Warden?

Warden is a gem that takes care of fetching authentication details from the request and fetching the user. Devise requires Warden to be added as a middleware. How it does that depends on the strategy we use for authentication. The default strategy is `database_authenticatable` [link](https://github.com/heartcombo/devise/blob/master/lib/devise/strategies/database_authenticatable.rb), but it can be changed using the model's `devise` helper method we saw above.

A strategy is the algorithm Warden will use to fetch the authentication information from the request, and validate it to fetch (or not) a valid object (usually a User object). Warden will call the `authenticate` method of the strategy and will expect either a call to `success!` (if the authentication if valid) or `fail` (if invalid).

```ruby
# lib/devise/strategies/database_authenticatable.rb

module Devise
  module Strategies
    # Default strategy for signing in a user, based on their email and password in the database.
    class DatabaseAuthenticatable < Authenticatable
      def authenticate!
        resource  = password.present? && mapping.to.find_for_database_authentication(authentication_hash)
        hashed = false

        if validate(resource){ hashed = true; resource.valid_password?(password) }
          ...
          success!(resource)
        end
        ...
          Devise.paranoid ? fail(:invalid) : fail(:not_found_in_database)
        ...
      end
    end
  end
end

Warden::Strategies.add(:database_authenticatable, Devise::Strategies::DatabaseAuthenticatable)
```

If the authentication details are valid, Warden will store the user in a Warden::Proxy object stored as a request environment variable at `request.env['warden']`. Later, this object is used by Devise to know the status of the authentication.

## After Warden

Since Warden is a middleware, the user authentication is validated before reaching Rails' controllers, that's why we can add authentication in the routes file.

Devise also adds some helper methods that include our model's class as the name, so we can use a model that's not called User and have semantic helper method names (if our model is Account, we can have an `authenticate_account` method). To do so, Devise uses some Ruby magic defining methods based on the module configuration:

```ruby
# lib/devise/controllers/helpers.rb

def self.define_helpers(mapping) #:nodoc:
  mapping = mapping.name

  class_eval <<-METHODS, __FILE__, __LINE__ + 1
    def authenticate_#{mapping}!(opts={})
      opts[:scope] = :#{mapping}
      warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
    end
    def #{mapping}_signed_in?
      !!current_#{mapping}
    end
    def current_#{mapping}
      @current_#{mapping} ||= warden.authenticate(scope: :#{mapping})
    end
    def #{mapping}_session
      current_#{mapping} && warden.session(:#{mapping})
    end
  METHODS

  ActiveSupport.on_load(:action_controller) do
    if respond_to?(:helper_method)
      helper_method "current_#{mapping}", "#{mapping}_signed_in?", "#{mapping}_session"
    end
  end
end
```

Here we can see how it adds new helper methods to our controllers using the mapping (our object's class) and some warden methods to check the status. These helper methods can also be used in the views.

> Warden uses the `scope` option so it can handle the authentication of multiple models if needed for the same browser session (we can have a User and an Admin model for example logged in at the same time).

Devise will also use Warden when creating a new session:

```ruby
# app/controllers/devise/sessions_controller.rb

def create
  self.resource = warden.authenticate!(auth_options)
  ...
end
```

Here, it tells Warden to validate the new authentication options. If valid, Warden will store the new user.

## Conclusion

Interestingly, a lot of the authentication is not handled by Devise but by the Warden gem, and Devise connects the wires between that and the Rails application, adding the needed configuration, views, controllers, helper methods, mailers, etc.
