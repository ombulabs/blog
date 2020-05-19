---
layout: post
title: "Better Software Design with Coupling and Cohesion"
date: 2020-05-19 12:30:00
categories: ["learning", "software-development"]
author: rdormer
---

One of the most fundamental tasks when writing or refactoring software
of any kind is breaking the problem down into smaller parts. When
you're first starting out - and even as you continue to gain
experience - figuring out what those parts should be, and where they
should live within a codebase can be a daunting task. Design patterns
and principles can help, but trying to keep them in mind as you design
and implement solutions can be overwhelming.

Thankfully, there's a pair of principles that can cut many of these gordian
knots, and render decision making much clearer, simpler, and easier to
articulate to others. Understanding and using the concepts of _coupling_ and
_cohesion_ to guide my design and refactoring decisions yielded
immediate results for me.

<!--more-->

Judging from a lot of the code that I've had
to work on over the years, I think it could help quite a few other developers
as well.

## The problem in a nutshell

A lot of my early design efforts tended to wind up with amorphously
defined "layers," catch-all classes full of random junk, and clunky
abstractions. I knew about a laundry list of design principles like
SOLID and DRY, [abstraction](https://simpleprogrammer.com/respecting-abstraction)
and design patterns. I knew that classes should "talk" to each other
as little as possible. But, when it came time to actually write (or
improve) code, the results were always somehow less than satisfactory.

Ideally, we want neatly factored designs with relatively small methods
and classes, each of which only does one thing, with zero side
effects. But as I tried to reach that ideal, I seemed to always wind
up with pieces - sometimes large pieces - of code that didn't
obviously belong in any particular place. Worse, they couldn't be put
anywhere without bloating already existing classes or otherwise
ruining the organization of the code. The question of "where should
this code live" is something that every working developer will run
into over and over again.

Learning about the twin concepts of [coupling and cohesion](https://wiki.c2.com/?CouplingAndCohesion)
suddenly clarified why I had been having trouble. Even better, all of the
other design principles suddenly made a much deeper and more cohesive
sense - all of them were just different ways of addressing these two
key principles.

## Coupling

Of the two concepts,
[coupling](https://en.wikipedia.org/wiki/Coupling_%28computer_programming%29)
is the one that most programmers are more likely to be familiar with.
Coupling refers to the degree to which two components - classes or
modules - interact with one another. It's a measure of how much they
"know" about each other. When you're reminded to keep methods that
aren't called by other classes private, you're hearing a half-hearted
stab at coupling. Marking methods private is just one way to reduce
the number of methods that any other part of the code can see or know
about. But coupling can also occur through data - which is why using
a global variable, for instance, is a code smell. Any class or module
that references the global variable is now coupled to all of the
others through that variable. Generally speaking, we want to reduce
coupling to the bare minimum needed to implement a solution.
Conveniently, there is a hierarchy of types of coupling. Personally,
I've found that learning about this hierarchy, and at least keeping it
in mind when designing software is worth the effort.

## Cohesion

The twin idea of Cohesion, for whatever reason, seems to be discussed
less often, probably because it can be a bit more abstract at first.
It's really just the inverse concept of coupling. Coupling tells us how
strongly modules and classes are connected to one another, while cohesion tells
us how strongly modules and classes are internally related to themselves.
[Cohesion](<https://en.wikipedia.org/wiki/Cohesion_(computer_science)>)
is the degree to which all of the methods and data structures in a
class or module are related to one another and belong together. A
module or class with a high level of cohesion will have elements that
all share a common purpose, while one with lower cohesion will be more
of a loosly organized collection of odds and ends. Perhaps one reason
Cohesion is not discussed as much is that it's easy to fall into the
trap of thinking that a highly cohesive set of methods must be tightly
coupled to one another, and therefore that the concept itself is just
a restatement of Coupling. This is not necessarily the case, though.
Ideally, a set of methods in a module or class would be _both_ loosely
coupled to one another, _and_ highly cohesive. Achieving that in the
real world can be challenging, but it's an ideal worth keeping in
mind. Like Coupling, there is a [hierarchy of different
levels](https://it.toolbox.com/blogs/craigborysowich/design-principles-cohesion-050307)
of cohesion. As with coupling, having an at least passing familiarity
with the different levels of Cohesion will change the way that you
approach writing new classes and modules, or refactoring existing
ones.

## Some examples

Like I said earlier, once you really start to understand coupling and
cohesion, you'll start to see how most good design practices are
really just ways of minimizing coupling and/or maximizing cohesion.
For instance:

- Most (if not all) of the design patterns listed as
  "structural" patterns in the [definitive
  reference](https://en.wikipedia.org/wiki/Design_Patterns) are ways of
  reducing coupling between different parts of a system by allowing you
  to re-use a single interface.
- For that matter, some of the "behavioral" patterns are explicitly described
  as reducing coupling.
- Encapsulation can also be viewed as simply
  preferring to create highly cohesive classes and modules. By creating
  data and code that live together, you are, by definition, creating
  more cohesive code.
- For those familiar with [SOLID](https://scotch.io/bar-talk/s-o-l-i-d-the-first-five-principles-of-object-oriented-design) principles, [Single Responsibility](https://stackify.com/solid-design-principles/) is
  basically a restatement of the idea of Cohesion.
- [Interface Segregation](https://devonblog.com/software-development/solid-violations-in-the-wild-the-interface-segregation-principle/) is also a way to increase cohesion by avoiding bloated, catch-all
  interfaces and the external coupling that they create.
- [Liskov Substitution](https://www.tomdalling.com/blog/software-design/solid-class-design-the-liskov-substitution-principle/) is a pretty straightforward example of
  reducing coupling.

## Final thoughts

As with any principle, you want to avoid over-simplifying things.
Design patterns, [SOLID](https://scotch.io/bar-talk/s-o-l-i-d-the-first-five-principles-of-object-oriented-design), and many other best practices have a lot more
going on than just coupling and cohesion. There are a lot of
considerations that go into designing software. But ultimately, you
have to start somewhere - and starting with a well grounded
understanding of these two basic principles is an excellent foundation
to build on. Personally, I've found that starting by considering
things from the inside out, so to speak, and focusing first on how to
make things as cohesive as possible tends to automatically reduce
coupling, and to lead directly to better design decisions. The next
time you have an opportunity to design or refactor a codebase, try
considering cohesion and its effect on coupling as a first principle
to guide you. I bet you'll be pleasantly surprised.
