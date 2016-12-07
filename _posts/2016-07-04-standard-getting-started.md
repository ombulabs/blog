---
layout: post
title: "The Need for bin/start"
date: 2016-07-04 12:31:00
categories: ["maintenance", "conventions"]
author: "etagwerker"
---

Getting started with a new project should be **as simple as possible**, even for
someone who is not technical. As a maintainer, you **must** make sure that
anyone can clone your project and get it up and running in a few minutes.

After you clone a project, you should follow two steps:

1. Setup
2. Start

<!--more-->

In this example, the project is a web application, but it works for other
projects too.

## Setup

You should have a small bash script called `bin/setup` in every project. You
could use [Ruby](https://www.ruby-lang.org/en/) for the script if that's
what you prefer.

[Rails](http://rubyonrails.org/) has had a `bin/setup` [since 2014](https://github.com/rails/rails/pull/15189) and so should your project! This is the default [./bin/setup](https://github.com/rails/rails/blob/v4.2.7.1/railties/lib/rails/generators/rails/app/templates/bin/setup) in a Rails application.

[Thoughtbot](https://robots.thoughtbot.com/) wrote a great article about
their `bin/setup` convention:
[./bin/setup](https://robots.thoughtbot.com/bin-setup)

At [Ombu Labs](http://www.ombulabs.com/), one of our latest `bin/setup` scripts
looks like this:

<script src="https://gist.github.com/etagwerker/956448c7a4b058b45e23f562deca8d79.js">
</script>

In order for our script to work, you **must** have a `.env.sample` file that
has some default values for your `.env` file. Every project you start **must**
have a `.env` file with environment configuration. Why?
[Read here](http://12factor.net/config)

We use [Ruby](https://www.ruby-lang.org/en/) for our setup script because all of
our development environments have been setup with this script:
[Ombu Labs Setup](https://github.com/ombulabs/setup)

## Start

If you are using Rails, starting an application is simple:

    ./bin/rails server

But, what if you want to use something else? Let's say you want to use
[Sinatra](https://github.com/sinatra/sinatra) with
[Shotgun](https://github.com/rtomayko/shotgun). Then you would need to start
the server like this:

    shotgun config.ru

If you are using [Bundler](https://rubygems.org/gems/bundler), then you would
need to run it like this:

    bundle exec shotgun config.ru

What if you want to use [Foreman](https://github.com/ddollar/foreman)?

     foreman start

You get the point. There are way too many ways to start a web application. We
need to **standardize** this into something flexible like `./bin/start`.

One of our latest `bin/start` scripts looks like this:

<script src="https://gist.github.com/etagwerker/e38b8021c0028f20d1f19932716d2c67.js">
</script>

From now on, all the web applications that we build at [Ombu Labs](http://www.ombulabs.com)
will be able to get started like this:

    ./bin/start

It won't matter if we use Foreman, Sinatra,
[Cuba](https://rubygems.org/gems/cuba), Rails, Shotgun, or whatever.
`bin/start` will know how to get the application started in a development
environment.

## Why

I love how simple it can be to tell anyone to clone the project and run these
steps:

    cd path/to/project
    ./bin/setup
    ./bin/start

A web designer that has no experience with Ruby/Rails can setup and start a
web application in a few minutes.

I'm a big fan of [Convention over Configuration](http://c2.com/cgi/wiki?ConventionOverConfiguration). Also, I hate
it when it takes me half a day to setup a new application in my environment. It
should **never** take more than a few minutes.
