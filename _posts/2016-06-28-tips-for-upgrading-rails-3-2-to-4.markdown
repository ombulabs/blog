---
layout: post
title: "Tips for upgrading from Rails 3.2 to 4.0"
date: 2016-06-28 11:08:00
categories: ["rails"]
author: "mauro-oto"
---

There are already quite a few guides in the wild to help with the upgrade of
Rails 3.2 to Rails 4.0.
The [official Rails guide](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-3-2-to-rails-4-0)
for upgrading from Rails 3.2 to 4.0 is very thorough.
With the upcoming release of Rails 5.0, apps currently in production running
Rails 3.2 should probably be updated to any stable Rails 4 release as soon as
possible.

Even an e-book on [upgrading Rails 3 to 4](https://github.com/alindeman/upgradingtorails4)
exists, which serves as a useful guide to make this upgrade easier and helps
understand the advantages & disadvantages of this new (soon to be old) version.

However, if you're using any non-standard gems, you're mostly on your own. Some
gems stopped being maintained before Rails 4 was released, as was the case
with [CanCan](https://github.com/ryanb/cancan), a well known authorization
library. After many open pull requests were left [unmerged](https://github.com/ryanb/cancan/pulls),
[CanCanCan](https://github.com/CanCanCommunity/cancancan) was released.
It is a community driven effort to have a semi-official fork of CanCan.
It serves as a drop-in replacement for those wanting to keep CanCan and upgrade
to Rails 4.

Along with the e-book mentioned before, the author released [a gem](https://github.com/alindeman/rails4_upgrade)
which you can add to your Rails 3 project which will help you with the upgrade:

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

The gem provides a Rake task, with the output shown above, so that instead of
going through your currently bundled gems or Gemfile.lock manually, you get a
report of what gems you will need to upgrade.

For an overview of your outdated gems, there's also `bundle outdated`, which you
can run on any project:

```
➜  myproject git:(develop) ✗ bundle outdated
Fetching gem metadata from http://rubygems.org/........
Fetching version metadata from http://rubygems.org/...
Fetching dependency metadata from http://rubygems.org/..
Resolving dependencies..........................................

Outdated gems included in the bundle:
  * aasm (newest 4.11.0, installed 3.0.26, requested ~> 3.0.22) in group "default"
  * activemerchant (newest 1.59.0, installed 1.47.0, requested ~> 1.47.0) in group "default"
  * acts_as_list (newest 0.7.4, installed 0.7.2, requested ~> 0.7.2) in group "default"
  * airbrake (newest 5.4.1, installed 4.1.0, requested ~> 4.1.0) in group "default"
  * awesome_nested_set (newest 3.1.1, installed 2.1.6, requested ~> 2.1.6) in group "default"
  * aws-sdk (newest 2.3.17, installed 1.64.0, requested ~> 1.64.0) in group "default"
  * byebug (newest 9.0.5, installed 5.0.0, requested ~> 5.0.0) in group "development"
  * cancancan (newest 1.15.0, installed 1.13.1, requested ~> 1.10) in group "default"
  * capistrano (newest 3.5.0, installed 3.4.0, requested ~> 3.0) in group "development"
  * capistrano-rails (newest 1.1.7, installed 1.1.5, requested ~> 1.1) in group "development"
  * capybara (newest 2.8.0.dev 59d21b5, installed 2.6.0.dev 3723805) in groups "test, cucumber"
  * capybara-webkit (newest 1.11.1, installed 1.7.1) in groups "test, cucumber"
  * codeclimate-test-reporter (newest 0.6.0, installed 0.4.8) in groups "test, cucumber"
  * compass (newest 1.0.3, installed 0.12.7) in group "default"
  * compass-rails (newest 3.0.2, installed 2.0.0) in group "default"
  * cucumber (newest 2.4.0, installed 1.3.20, requested ~> 1.3.10) in groups "test, cucumber"
  * cucumber-rails (newest 1.4.3, installed 1.4.2, requested ~> 1.4.0) in groups "test, cucumber"
  * database_cleaner (newest 1.5.3, installed 1.5.1, requested ~> 1.5.1) in groups "test, cucumber"
  * devise (newest 4.1.1, installed 2.1.4, requested ~> 2.1.0) in group "default"
  * ...
```

Last but not least, there's the `rails:update` task, which you can use as a
guideline as explained very clearly in [this post](http://thomasleecopeland.com/2015/08/06/running-rails-update.html)
to get rid of unnecessary code or monkey-patches, especially if your Rails 3
app was previously running on Rails 2.
