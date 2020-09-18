---
layout: post
title: "Introducing Pecas: Dashboards for Noko"
date: 2016-06-06 9:31:00
reviewed: 2020-09-15 10:00:00
categories: ["open-source"]
author: "etagwerker"
---

At [OmbuLabs](https://www.ombulabs.com) we are big fans and happy customers
of [Noko](https://nokotime.com/). We use their widget to track all the
hours that we spend on client projects,
[open source](https://www.ombulabs.com/#open-source) development, and
[our own products](https://www.ombulabs.com/#products).

Today I'm happy to introduce [Pecas, time tracking leaderboards for Noko](http://fastruby.github.io/pecas/)! **Pecas** is an
[open source](http://github.com/fastruby/pecas) tool that integrates with your
account and generates beautiful leaderboards per project and per teammate.

Here is a sample dashboard for all your projects:

<img src="/blog/assets/images/pecas_by_project.jpg" alt="A sample leaderboard in the Pecas web interface" class="full-img">

On top of that, it will send you an *email alert* if you haven't tracked any hours
during a work day. If it's a holiday, it won't bother you. :)

<!--more-->

I like to check it out every week to see if we are on track for our [time and material](https://www.ombulabs.com/blog/software-development/time-and-material.html)
projects. We need to work 40 hours per week for some of our clients and it's a
good way to detect deviations.

To build this small application we decided to use
[Rails 4.2](http://rubyonrails.org/) and the
[Noko API v2](https://developer.nokotime.com/). You can easily
set it up using [Heroku](http://heroku.com) and your Noko API key: [https://github.com/ombulabs/pecas#first-time-only](https://github.com/fastruby/pecas#first-time-only)

If you like [Noko](https://nokotime.com/) as much as we do, feel free to
**fork Pecas** in [Github](https://github.com/fastruby): [https://github.com/fastruby/pecas](https://github.com/fastruby/pecas)
