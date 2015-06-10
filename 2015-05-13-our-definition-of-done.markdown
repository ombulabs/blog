---
layout: post
title:  "Our definition of Done"
date:   2015-05-13 11:37:00
categories: ["software development", "software quality"]
---

When is a feature done?

* It does what it is expected
* If it has a user interface, the UX is simple and good enough: A human can use it
* If it is code for other programmers, the public contract is clear: A programmer read the documentation and use it
* It has a decent spec, which covers at least two scenarios (not just the happy path)
* It is fast!
* The build passes (it doesn't break any of the existing specs)
* The code is easy to maintain (DRY'ed)

Quality should be present in everything you do, but it should be balanced with the time you spend in a feature.

Have you spent 2 days in a feature that should've been done in 2 hours? If so, why?

If the feature is big, break it into smaller features. This will make it easier to move ahead.

Before you submit your pull request, make sure that you have considered this.
