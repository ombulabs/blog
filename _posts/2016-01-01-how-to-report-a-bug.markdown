---
layout: post
title: "How to report a bug"
date: 2016-01-01 13:55:00
reviewed: 2020-03-05 10:00:00
categories: ["open-source", "bugs"]
author: "etagwerker"
---

The simplest way to contribute to an open source project is to file an issue. Here are a few steps for you to file issues that are useful for the project maintainers.

### 1. Make sure it hasn't been reported yet

A quick Google search should return one or more results about the issue. If it's user error, just change the way you are using the code and move on.

If that doesn't work, find the project (it's probably on [Github](https://github.com)) and search through open and closed issues. If it's filed and open, try to add more information to make it easier to solve. (_Please please please_ don't just add another **+1** to a series of **+1s**)

If you couldn't find any issues, submit an issue (_Beware_: some projects will encourage you to post to their mailing list _before_ filing an issue)

### 2. Submit a useful issue report

Don't just post the title of the error and what you were doing when it happened.

**Please be as specific as possible!**

Post information about:

* The environment (a snapshot of Gemfile.lock could help)
* The error message (a good candidate for the issue's title)
* The backtrace should **always** be included in the description
* If there is some configuration involved, add it to the description

### 3. Bonus points

* Try a couple of alternatives and see what results you get. Save all the output, which might be useful for the issue's resolution. I know that most of us try different solutions before filing an issue.

* If you want to show the maintainer an example of the problem, you could create a sample application that generates the problem, using the same configuration and the same dependencies you have in your application.

* If you found the problematic line in the library, you could enhance the tests to cover the scenario that you are seeing. The best libraries have near 100% code coverage, so adding another scenario could be easier than you think. You don't need to find the solution, but seeing a failing spec will definitely make it easier to find a solution.

### 4. Share your monkeypatch

Most of us will [monkeypatch](http://devblog.avdi.org/2008/02/23/why-monkeypatching-is-destroying-ruby) our application and move on. **This sucks!**

You should file the issue, so that other programmers will benefit from your "wasted" effort.

If you monkeypatched it in a horrible way, add it to the issue as well. The project maintainer or other programmers might find that it isn't such a horrible patch after all.

### To sum things up

I've explained a couple of ways that you can make a contribution to an open source project. I started with the simpler steps and then I moved on to the more advanced contributions.

Ideally, detailed issue reports will become pull requests in the future. You (or someone else) might send the pull request, but it all begins with a detailed description of the problem you are seeing.

Don't just say _"It doesn't work!"_, don't be that person! Next time file an issue so that we can all benefit from your pain.
