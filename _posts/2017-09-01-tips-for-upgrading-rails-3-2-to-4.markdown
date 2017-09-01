---
layout: post
title: "The definitive guide to upgrading from Rails 3.2 to 4.0"
date: 2017-09-01 16:48:00
categories: ["rails", "upgrades"]
author: "mauro-oto"
---

_This article is part of our Upgrade Rails series. To see more of them, [click here](https://www.ombulabs.com/blog/tags/upgrades)_.

A [previous post](https://www.ombulabs.com/blog/rails/tips-for-upgrading-rails-3-2-to-4.html)
covered some general tips to take into account for this migration. This article
will try to go a bit more in depth. We will first go from 3.2 to 4.0, and then
to 4.2. Depending on the complexity of your app, a Rails upgrade can take
anywhere from one week for a single developer, to a few months for two developers.

1. Ruby version
2. Gems
3. Config files (config/)
4. Application code
  a. Models (app/models/)
  b. Controllers (app/controllers/)
5. Tests
6. Miscellaneous
7. Next steps

## 1. Ruby version

Rails 3.2.x is the last version to support Ruby 1.8.7. If you're using Ruby 1.8.7,
you'll need to upgrade to Ruby 1.9.3 or newer. The Ruby upgrade is out of the scope
of this guide, but check out [this guide](http://www.darkridge.com/~jpr5/2012/10/03/ruby-1.8.7-1.9.3-migration), which
is very complete and serves as a sort of checklist, and we've used it in the past.

## 2. Gems

You can add the aptly named [rails4_upgrade gem](https://github.com/alindeman/rails4_upgrade)
to your Rails 3 project's Gemfile and find gems which you'll need to update:

```
➜  myproject git:(develop) ✗ bundle exec rake rails4:check

** GEM COMPATIBILITY CHECK **
+------------------------------------------+----------------------------+
| Dependency Path                          | Rails Requirement          |
+------------------------------------------+----------------------------+
| devise 2.1.4                             | railties ~> 3.1            |
| devise-encryptable 0.2.0 -> devise 2.1.4 | railties ~> 3.1            |
| friendly_id 4.0.10.1                     | activerecord < 4.0, >= 3.0 |
| strong_parameters 0.2.3                  | actionpack ~> 3.0          |
| strong_parameters 0.2.3                  | activemodel ~> 3.0         |
| strong_parameters 0.2.3                  | activesupport ~> 3.0       |
| strong_parameters 0.2.3                  | railties ~> 3.0            |
+------------------------------------------+----------------------------+
```

Instead of going through your currently bundled gems or `Gemfile.lock` manually,
you get a report of the gems you need to upgrade.

## 3. Config

Rails includes the `rails:update` [task](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#the-update-task),
which you can use as a guideline as explained thoroughly in
[this post](http://thomasleecopeland.com/2015/08/06/running-rails-update.html)
to get rid of unnecessary code or monkey-patches in your config files and
initializers, specially if your Rails 3 app was running on Rails 2.

As an alternative, check out [RailsDiff](http://railsdiff.org/3.2.22.5/4.0.13),
which provides an overview of the changes in a basic Rails app between 3.2 and
4.0 (or any other source/target versions).

If you're feeling adventurous, you
can give [this script](https://github.com/bsodmike/upgrade_rails_3.2.12_to_4.0.0.beta1)
a try. It attempts to apply [this git patch](https://github.com/bsodmike/upgrade_rails_3.2.12_to_4.0.0.beta1/blob/master/upgrade/upgrade.patch)
(similar to the patch shown on RailsDiff) to your Rails app to migrate from 3.2
to 4.0. However, I don't recommend this for complex or mature apps, as there
will be plenty of conflicts.

## 4. Application code

### a. Models

- All dynamic finder methods except for `.find_by_...` are deprecated:

```ruby
# before:
Authentication.find_all_by_provider_and_uid(provider, uid)

# after:
Authentication.where(provider: provider, uid: uid)
```

You can regain usage of these finders by adding the gem
[activerecord-deprecated_finders](https://github.com/rails/activerecord-deprecated_finders)

- ActiveRecord scopes now need a lambda:

```ruby
# before:
default_scope where(deleted_at: nil)

# after:
default_scope { where(deleted_at: nil) }

# before:
has_many :posts, order: 'position'

# after:
has_many :posts, -> { order('position') }
```

- Protected Attributes are deprecated, but you can add the [gem for it](https://github.com/rails/protected_attributes).
However, since the Rails core team dropped its support since Rails 5.0, you
should begin migrating your models to Strong Parameters anyway.

- ActiveRecord Observers were removed from the Rails 4.0 codebase and extracted
into a gem. You can regain usage by adding the gem to your Gemfile:

```ruby
gem 'rails-observers' # https://github.com/rails/rails-observers
```

As an alternative, you can take a look at the [wisper gem](https://github.com/krisleech/wisper),
or Rails' Concerns (which were added in Rails 4.0) for a slightly different
approach.

- ActiveResource was removed and extracted into its own gem:

```ruby
gem 'active_resource' # https://github.com/rails/activeresource
```

### b. Controllers

- ActionController Sweeper was extracted into the `rails-observers` gem, you can
regain usage by adding the gem to your Gemfile:

```ruby
gem 'rails-observers' # https://github.com/rails/rails-observers
```

- Action caching was extracted into its own gem, so if you're using this feature
through either:

```ruby
caches_page   :public
```

or:

```ruby
caches_action :index, :show
```

You will need to add the gem:

```ruby
gem 'actionpack-action_caching' # https://github.com/rails/actionpack-action_caching
```

## 5. Tests

From Ruby 1.9.x onwards, you have to include the [`test-unit` gem](https://rubygems.org/gems/test-unit)
in your Gemfile as it was removed from the standard lib. As an alternative,
migrate to `Minitest`, `RSpec` or your favorite test framework.

## 6. Miscellaneous

- Routes now require you to specify the request method, so you no longer can
rely on the catch-all default.

```ruby
# change:
match '/home' => 'home#index'

# to:
match '/home' => 'home#index', via: :get

# or:
get '/home' => 'home#index'
```

- Rails 4.0 dropped support for plugins, so you'll need to replace them with gems,
either by searching for the project on [RubyGems](https://rubygems.org)/[Github](https://github.com),
or by moving the plugin to your `lib` directory and require it from somewhere
within your Rails app.

## 7. Next steps

If you're running Rails 4.0, congratulations!

Stay tuned for our Rails 4.0 to Rails 4.2 article, check out our [Rails performance articles](https://www.ombulabs.com/blog/tags/performance) to fine-tune
your app, and feel free to tell us how your upgrade went.
