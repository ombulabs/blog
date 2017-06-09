---
layout: post
title:  "Upgrade Rails from 2.3 to 3.0"
date: 2017-06-09 16:06:00
categories: ["rails"]
author: "luciano"
---

This article is the first of our Upgrading Rails series. To see more of them, [follow this link.](https://www.ombulabs.com/blog/tags/upgrading-rails)

<!--more-->

1. Considerations
2. Ruby version
3. Tools
4. Config files
5. Gems
6. Active Record

## 1. Considerations
Before beginning with the upgrade process, we recommend that each version of your Rails app has the latest [patch version](http://semver.org) of it before move to the next major/minor version.
For example, in order to follow this article, your [Rails version](https://rubygems.org/gems/rails/versions) should be at 2.3.18 before move to Rails 3.0.20

## 2. Ruby version
Rails 3.0 requires Ruby 1.8.7 or higher, but no more than 1.9.3. If you want to use Ruby 1.9.x, we recommend to jump directly to 1.9.3. Also Ruby 1.9.1 is not usable because it has segmentation faults on Rails 3.0. So the compatible Ruby versions for Rails 3.0 are 1.8.7, 1.9.2, or 1.9.3.

## 3. Tools
There is an [official plugin](https://github.com/rails/rails_upgrade) that helps a lot in the upgrade process. You just need to install the script by doing `script/plugin install git://github.com/rails/rails_upgrade.git` and then run `rake rails:upgrade:check` to see most of the files you need to upgrade in your application. It also provides some others generators to upgrade specific areas in you app like routes or gems.

Sometime it's also useful to check which files changed between two specifics versions of Rails. Fortunately [this website](http://railsdiff.org/2.3.18/3.0.0) makes that easy.

## 4. Config files
Rails 3 introduces the concept of an Application object. An application object holds all the application specific configurations and it's similar to the current config/environment.rb from Rails 2.3. The application object is defined in config/application.rb. You should move there most of the configuration that you had in config/environment.rb.

In terms of routes, there are a couple of changes that you need to apply to your routes.rb file. For example:

```
# Rails 2.3 way:

ActionController::Routing::Routes.draw do |map|
  map.resources :products
end

# Rails 3.0 way:

AppName::Application.routes do
  resources :products
end
```
You can go to [this article](https://blog.engineyard.com/2010/the-lowdown-on-routes-in-rails-3) to see in depth about this topic.

## 5. Gems
[Bundler](https://bundler.io/) is the default way to manage Gem dependencies in Rails 3 applications. Now you need to add a [Gemfile](https://bundler.io/v1.15/gemfile_man.html) in the root of your app, define all you gems there, and then get rid of the config.gem.

Remember that if you installed the plugin mentioned in step 3, you can run `rake rails:upgrade:gems`. This task will extract your config.gem calls and generate code you can put into a bundler compatible Gemfile.

## 6. Active Record
There are a bunch of deprecations that happens during this version:


- The method to define a named scope is now called `scope` instead of `named_scope`

- In scope methods, you no longer pass the conditions as a hash:

```
# Before:
named_scope :active, :conditions => ["active = ?", true]


# Now:
scope :active, where("active = ?", true)
```

- `save(false)` is deprecated, you should use `save(:validate => false)`.

- I18n error messages for Active Record should be changed from `:en.activerecord.errors.template` to `:en.errors.template`.

- `model.errors.on` is deprecated in favor of `model.errors[]`

- Syntax of presence validations:

```
# Before:
validates_presence_of :email

# Now:
validates :email, presence: true
```

- `ActiveRecord::Base.colorize_logging` and `config.active_record.colorize_logging` are deprecated in favor of `Rails::LogSubscriber.colorize_logging` or `config.colorize_logging`
