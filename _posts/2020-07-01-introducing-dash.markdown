---
layout: post
title: "Introducing Dash - An open source dashboard from OmbuLabs"
date: 2020-07-01 12:00:00
categories: ["open-source"]
author: fionadl
---

At OmbuLabs we are always trying to find or create tools to help our processes and workdays run as smoothly and efficiently as possible. For the past few months we have been developing just such a tool, and recently we made it open source. [Dash](https://github.com/fastruby/dash) is a dashboard application written in Ruby on Rails that integrates open pull requests and issues from [GitHub](https://github.com/) with [Pivotal Tracker](https://www.pivotaltracker.com/) stories.

<!--more-->

<img src="/blog/assets/images/dash.png" alt="dash ombulabs" class="medium-img">

## Why

We created this dashboard so that we can see a full list of our todos all in one spot. Dash allows the user to sync up to the latest information available on Github and Pivotal Tracker and see it all in one organized list. Sometimes it's difficult to keep track of the todos when they come from different programs, but now we have an app that shows us a simple layout of everything on our lists.

## What

When Dash syncs with open pull requests in an organization it checks the pull requests to see if the current user is a requested reviewer or an assignee, and then it adds that pull request to the current todo list. For issues Dash checks to see if the current user is an issue assignee, and for Pivotal Tracker stories it checks to see if the current user is an owner of a story.

## Tasks

Dash also has rake tasks available for updating each issue or pull request that is already in the database to see what the status is and if assignees, or reviewers have changed. We use these rake tasks to set up schedulers in Heroku so that our todo lists stay up to date without having to constantly sync them.

## Open Source

Contributing to open source and building open source projects are a very important part of OmbuLabs [values](https://www.ombulabs.com/blog/values/our-values.html). We have decided to make Dash an open source project in case any other companies are using these same resources and might find this application a helpful addition to their toolset.

We are continuing to work on Dash, but also we are now inviting the Ruby on Rails community to join in. You can also read more about what we have been working on in open source this year [here](https://www.ombulabs.com/blog/open-source/open-source-report-q1.html).
