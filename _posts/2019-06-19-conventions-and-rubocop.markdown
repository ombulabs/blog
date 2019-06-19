---
layout: post
title: "Code Conventions and Rubocop"
date: 2019-06-19 09:00:00
categories: ["ruby", "best-practices"]
author: "rdormer"
---

Everyone has had the experience of working on a gnarly, difficult to
understand code-base.  The sort of code base that makes you hate your
job.  Often it comes down to poor design, but [code
conventions](https://en.wikipedia.org/wiki/Coding_conventions) also
play a large part in whether you wake up dreading your job in the
morning.  The overall design (choice of design patterns and how
modules and classes are organized and factored) is the long range, big
picture strategy of how an application will be made.  Code
conventions, by contrast, come down to the choices you make about
which constructs of a language you use, which you don't, and when.

<!--more-->

How you name variables, functions, classes, and how you organize and
implement control logic determine a lot of the day to day nitty gritty
of getting your brain dirty and confused.  By themselves, conventions
won't necessarily derail a project the way that a poorly chosen design
might, but they can easily end up chewing up time - and therefore
money.

# Choose Wisely

The main arguments for code conventions come down to readability.  By
enforcing a standard style, code becomes more uniform.  Code that's
more uniform becomes easier to read and understand once you get used
to the conventions - and readability is hugely important, since the
author of a piece of code will probably have the *least* interaction
with it over the life of that code.  But more than that, well chosen
conventions make writing code easier by *removing* the number of
choices you can make while writing code - even if you don't like the
idea of being restricted, it's unquestionably easier to write code
when you don't have to spend a lot of time thinking about how to name
variables or classes (for instance) because there's really only one
way you're allowed to do it.

Of course, developers love to disagree, and any conventions like this
will inevitably be a potential source of griping.  From experience,
it'll be a fraction of the complaining you'll hear if you *don't* have
standard conventions, though.  Even the most opinionated developers
will be professional enough to get used to it in short order.  Whether
they admit it or not, most experienced developers would rather have a
convention they're not crazy about than no conventions at all.

# Picking Lint

There's nothing new about these ideas, by the way.  They go all the
way back to the late seventies, when the
["Lint"](https://en.wikipedia.org/wiki/Lint_(software)) utility for C
first came out.  Developers back then were facing the task of porting
some of the initial versions of Unix and it's various utilities to
different platforms.  Through hard won experience and trial and error,
they learned that certain constructs in the language were "unsafe",
make it harder to port code from one platform to the next.  It was a
natural extension from there to note that certain practices also made
the code harder to read - and therefore maintain.

Lint was enthusiastically embraced, and the underlying idea has since
been repeated over and over again - at this point, it's fair to say
that a language can't be considered to have arrived until it has,
among other things, it's own Lint style tool.  This is important
because these tools will often wind up as de-facto archives of the
learned experiences of developers using the language, codifying what
tends to make code generally readable to the workaday programmer, and
what does the opposite.  Constructs that are obscure or unreadable,
and constructs that have proven to be rich sources of bugs, will be
accordingly documented and flagged - often with justifications for
why.  Reading this documentation, if it's available, can be an
excellent way to learn how to write solid, idiomatic code in a given
language.  If you're learning a new language, such style guides are a
natural next stop after you've mastered the basics.

# Rubocop

If you don't know by now,
[Rubocop](https://github.com/rubocop-hq/rubocop) is the de-facto Lint
equivalent for Ruby code.  The [Style
Guide](https://github.com/rubocop-hq/ruby-style-guide) is an excellent
example of communally created conventions, complete with
justifications and links to ancillary documentation.   Like any self
respecting Lint style tool, it recognizes that programmers love to
disagree, and allows you to set up your own Ruleset or
[disable](https://rubocop.readthedocs.io/en/latest/configuration/)
rules you disagree with, either globally, or on a case by case basis.

If you're using Git, then it's straightforward to add Rubocop checking
to your pre-commit hooks, making style checks an automatic part of
every developer's workflow.  This is probably better than integrating
it into something more centralized, like a Jenkins server - it's best
that code doesn't make it into your repository unless it conforms to
conventions, rather than flagging it after the fact.

# StandardRB

If Rubocop looks like a bit much for you right now, there's a lighter weight
alternative in [StandardRB](https://github.com/testdouble/standard).  Think of
it as a largely pre-configured version of Rubocop, leaving you with a simple and
relatively stripped down set of rules to deal with.  It's a solid way to start
enforcing conventions without diving into the minutiae.

# Getting over the hump

If you're starting out with an existing code base, then as soon as you
integrate Rubocop into the picture, you'll get dozens if not hundreds
of style violations.  No worries, Rubocop has you covered.  The handy
[autocorrect](https://rubocop.readthedocs.io/en/latest/auto_correct/)
mode will fix violations automatically.  If that's a little aggressive
for your tastes, then you can just generate a
[rubocop_todo.yml](https://rubocop.readthedocs.io/en/latest/configuration/#automatically-generated-configuration)
file that will disable checking for all *existing* violations while
still flagging any new violations going forward.  You can then circle
back and fix up your existing code, treating it as a part of your
existing technical debt.
