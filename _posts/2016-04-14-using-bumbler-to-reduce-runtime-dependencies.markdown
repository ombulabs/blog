---
layout: post
title: "Using Bumbler to reduce runtime dependencies"
date: 2016-04-25 11:39:00
categories: ["ruby", "performance"]
author: "mauro-oto"
---

A few weeks ago, I found an interesting project called
 [Bumbler](https://github.com/nevir/Bumbler). If your project uses Bundler,
 Bumbler shows you your project's largest dependencies.
When you find yourself staring at the screen after running
 `bundle exec rails c`, you may want to give this tool a try.

<!--more-->

Using it is simple. Add `gem 'bumbler'` to your Gemfile under the development
 group, run `bundle`, and you're good to go.
 When you run `bundle exec bumbler` you will see a progress bar and a detail of
 the dependencies which took the longest to load.
Here's an example of a project's development dependencies:

```
➜  git:(master) ✗ bundle exec bumbler
[#################################################                             ]
(49/65) travis-lint...
Slow requires:
    110.21  render_anywhere
    147.33  nokogiri
    173.83  haml
    179.62  sass-rails
    205.04  delayed_job_active_record
    286.76  rails
    289.36  mail
    291.98  capistrano
    326.05  delayed_job
    414.27  pry
    852.13  salesforce_bulk_api
```

As you can see, one of the gems takes almost 1 second to load on my system,
 and removing it decreases the time it takes for `bundle exec rails c` to load
 by 1 second. It's not a lot, but consider every Rake task you run which depends
 on the environment will take 1 less second to get started.

After we get rid of `salesforce_bulk_api` and `render_anywhere` and manually
 call `require` on them when needed, the load time looks like this:

```
➜  git:(master) ✗ bundle exec bumbler
[#################################################                             ]
(47/65) fog-aws...
Slow requires:
    167.50  sass-rails
    188.87  nokogiri
    218.49  haml
    230.10  capistrano
    253.77  delayed_job_active_record
    284.26  mail
    320.19  delayed_job
    365.67  pry
    464.09  rails
```

Your tests can also benefit from this, as you may find gems that you do not need
 to have in the test environment. Capistrano is one example, usually you want
 to have it load **only** in development, not in test nor production.

One caveat worth mentioning: you need to take a close look at your loaded gem's
 dependencies when removing them. For example, `capistrano` depends on
 `net-ssh` and `net-scp`. If you remove `capistrano` from `test` or
 `production`, you won't be able to use `Net::SSH` or `Net::SCP` unless you
 manually add the `net-ssh` and `net-scp` dependencies back in your Gemfile, as
 you were relying on them implicitly via Capistrano.
