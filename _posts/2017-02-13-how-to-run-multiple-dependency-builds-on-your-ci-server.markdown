---
layout: post
title:  "How to run multiple dependent builds on Circle CI"
date: 2017-02-23 15:21:00
categories: ["continuous-integration", "circle-ci"]
author: "luciano"
---

We all know the importance of having a [CI](https://en.wikipedia.org/wiki/Continuous_integration) tool integrated in your project. It allows you to run your entire test suite every time you want to merge a set of changes.
If you have a core project and many projects that depend on it, you want to run the tests for the core project and the dependent projects at the same time. This article explains how you can do it with [Circle CI](https://circleci.com).

<!--more-->

I will explain how to do that with two [Rails](http://rubyonrails.org) projects (an application and an [engine](http://guides.rubyonrails.org/engines.html))

In this example we have an app called `my-app` and an engine called `my-gem`.
In `my-app/Gemfile` we should have something like this:

```
gem 'my-gem', git: 'git@github.com:ombulabs/my-gem.git', tag: '1.0.0'
```

In order to edit the default settings of CircleCI, you need to have a `circle.yml` file in your project directory. You can check the [documentation](https://circleci.com/docs/configuration/) to help you complete each section.

The idea is that every time we push changes to the engine's repo (`my-gem`), the CI runs its tests automatically. Afterwards, the CI should also run the tests of the dependent projects (in this example it will be only `my-app`) pointing to the current branch of `my-gem`. So, basically we need to apply these steps on the `my-gem/circle.yml`.

### Clone the dependent project (my-app)

`git clone -b develop git@github.com:ombulabs/my-app.git ../my-app`

### Edit the Gemfile and point my-gem to the current branch

`"sed -i \"s@tag.*@branch: '${CIRCLE_BRANCH}'@\" ../my-app/Gemfile"`

### Setup the project

```
(cd ../my-app && gem install bundler --no-ri --no-rdoc)
(cd ../my-app && bundle)
(cd ../my-app && bundle exec rake db:create db:schema:load)
```

### Run the tests

`(cd ../my-app && bundle exec rake)`

The best place to put all of that is after running the main test. So, your `circle.yml` should look like this:

```
test:
  post:
    - git clone -b develop git@github.com:ombulabs/my-app.git ../my-app
    - "sed -i \"s@tag.*@branch: '${CIRCLE_BRANCH}'@\" ../my-app/Gemfile"
    - (cd ../my-app && gem install bundler --no-ri --no-rdoc)
    - (cd ../my-app && bundle)
    - (cd ../my-app && bundle exec rake db:create db:schema:load)
    - (cd ../my-app && bundle exec rake)
```

Obviously, the build will be slower than before because now it's running two projects inside the same build. But this ensures that your dependent projects won't crash after updating the references to the gem (engine).
