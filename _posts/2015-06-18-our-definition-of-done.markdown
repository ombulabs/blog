---
layout: post
title:  "Our Definition of \"Done\""
date: 2015-06-18 11:37:00
reviewed: 2020-03-05 10:00:00
categories: ["software-development", "software-quality"]
author: etagwerker
---

Quality should be present in everything you do, but it should be balanced with the time you spend working on a feature. Does it feel like you've been working on this feature for a **really long time**? Maybe you have. Is it "done"?

That is a tough question, so I'll write down _our definition of done_.

<!--more-->

## When is a feature done?

* The feature does what it is expected to do
* If it has a user interface, the [UX](http://www.helloerik.com/ux-is-not-ui) is simple and good enough: A _human_ can use it!
* If it is code for other programmers, the [public contract](http://c2.com/cgi/wiki?InterfaceSegregationPrinciple) is clear: A programmer read the documentation and use it
* It has a [decent spec](http://c2.com/cgi/wiki?CodeCoverage), which covers at least two scenarios (not just the happy path)
* It is fast!
* The build passes (it doesn't break any of the existing specs)
* The code is easy to maintain ([DRY](http://c2.com/cgi/wiki?DontRepeatYourself)'ed)

Have you spent 2 days in a feature that should've been done in 2 hours? Have you spent 2 hours on a bug fix that should've taken you 8 hours? If so, why?

If the feature is big, break it into smaller features. This will make it easier to move ahead.

Before you submit your [pull request](https://help.github.com/articles/using-pull-requests), make sure that you have considered this list.
