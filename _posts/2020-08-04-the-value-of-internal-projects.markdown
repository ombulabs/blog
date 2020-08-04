---
layout: post
title: "The Value of Internal Projects"
date: 2020-08-04 12:00:00
categories: ["software-development", "open-source"]
author: rdormer
---

With the constant pressure to both find and then execute on client
projects, agencies often lose sight of the possibility of working on
internal projects. While the initial reaction is often to dismiss them
as a distraction from the important client facing work, carefully
chosen interal projects can be very valuable. Aside from the obvious
benefit of solving internal problems that might not have a readily
available solution, they also provide training opportunities for
developers. They give you a chance to try new ways of
doing things with relatively low risk, or perhaps preview new
languages and frameworks you've been considering.

<!--more-->

Here at OmbuLabs, we use internal projects for all of these reasons,
and we've found them to be a valuable part of our company culture.
Here's a brief sampling of the most prominent ones we've been working
on:

[Dash](https://www.ombulabs.com/blog/open-source/introducing-dash.html) - While
Github and Pivotal integrate reasonably well, we found that what they provided
didn't quite match our desired workflow. We needed more than just a way to link
Github activity to Pivotal stories. We wanted to have an overview of both in
dashboard form. Dash lets us see our open stories and PRs together in one place.

Points - As a development agency, estimating projects is a critically
important task, and one that's worth spending significant effort to
get right. Getting estimates wrong has consequences in any business,
but when you're doing the work for other people, those consequences
can be especially bad. One thing we quickly figured out is that when
it comes to estimates, two heads are better than one. Points is a tool
that we developed so that multiple developers, typically the ones who
will be doing the actual work, can weigh in with their estimates. The
band of estimated values that develops has turned out to be
surprisingly accurate in most cases - and those cases where it hasn't
have invariably been important learning opportunities.

[Our Blog](https://www.ombulabs.com/blog) - The very blog you're
reading now is an in-house project. We looked at a few different
options for adding a blog to our website, but none of them really fit
the bill. They either lacked features we wanted, or didn't integrate
as seamlessly with our main site as we wanted.

[Fast Ruby](https://fastruby.io) - As a productized service offering, a
pre-canned template site simply wasn't an option here. We knew the
design and concept for the site would most likely change quite a bit
over time, so a custom written site was the way to go.

[Ombushop](https://www.ombushop.com) - This started life as a flagship
project by our founder, intended to address a lack of e-commerce
options in Latin American countries. It's also a useful case study for
our Rails development services.

As developers, there's always a temptation for us to start writing our
own tools the minute we find a problem with no obvious off the shelf
solution. While creating your own is all well and good, it's still a
good idea to stop and ask yourself if you _really_ need to. Sometimes
you really can solve a problem you have with an existing service or
tool, if you just look a little harder. Like most organizations, we
struggled with documenting organizational knowledge for a long time.
Like many of you, we initially tried using Wiki software as the
repository for our internal documentation. Like many who've gone this
route before us, we found it somehow didn't quite fit the bill - we
wanted internal documentation, not an internal encyclopedia - and it
wound up languishing. We cast around for alternatives for a long time,
until we found [Tettra](https://tettra.com/), which seems to do the job for now.

We've found that carefully, mindfully considering internal problems
and implementing our own solutions to them where necessary is a useful
exercise for trying new things, and for honing our skills at
evaluating problems. The next time you hit a pain point in your shop,
ask yourself: what's the simplest solution that we can build ourselves
that will solve this, and how else can I make it valuable? Is this an
opportunity to try that new framework we've been interested in? Or a
good chance for a more junior developer to get a rare opportunity to
do some greenfield development? Try a few carefully chosen internal
projects, and see for yourself if it ends up being a useful exercise.
If you're anything like us, you'll find that more often than not, they
are.
