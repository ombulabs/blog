---
layout: post
title: "The Joys and Woes of Pair Programming"
date: 2016-05-12 14:37:00
reviewed: 2020-03-05 10:00:00
categories: ["agile", "pair-programming"]
author: "etagwerker"
---

There are a few [agile practices](https://en.wikipedia.org/wiki/Agile_software_development#Agile_practices) that **I really love**. [Pair programming](http://c2.com/cgi/wiki?PairProgramming)
is one of them.

We try to do it as much as possible at [OmbuLabs](https://www.ombulabs.com). We
usually keep the sessions under **two hours** and try to follow a regular
schedule.

When we find ourselves **blocked** by a code problem, we use our daily scrum to
coordinate a **pairing session**. It's quite a step up from _[rubberducking](http://c2.com/cgi/wiki?RubberDucking)_ or using a _[cardboard programmer](http://c2.com/cgi/wiki?CardboardProgrammer)_ to find a **solution**
to a problem.

<img src="/blog/assets/images/pair-programming.jpg" alt="@mauro_oto and I pair programming" class="full-img">

## The Joys

As a _Senior_ developer, I find that pairing sessions are great for coaching
_Junior_ developers. I enjoy teaching them about best practices, design
patterns, frameworks, languages, code style,
[XP](http://c2.com/cgi/wiki?ExtremeProgramming), and
[TDD](http://c2.com/cgi/wiki?TestDrivenDevelopment).

From the point of view of a _Junior_ developer, I believe it's a
**great opportunity** to **learn** from someone who "has been there before".
When you program with someone with more experience, you will often learn about
design patterns, elegant object-oriented solutions, tips and tricks.

<!--more-->

As a _Senior_ developer, pair programming is a great way to mentor a _Junior_
developer. It's also a good way to get better at explaining some of the things
you know and to learn in the process.

When I'm struggling, it's great to have a **sounding board** for my ideas. It's
useful to have a **brainstorming** session about potential solutions to a
problem. We all know that for every problem there is a:

* 2 hours solution
* 2 days solution
* 2 weeks solution

_[I used *2* but it could be *n*. You get the point]_

Pairing with someone you put everything in **perspective**. You evaluate your
resources, your limitations and you explore the different solutions until you
find something that is both elegant and pragmatic for both of you.

When you pair, you tend to avoid **ugly hacks** because someone is right there
watching what you are doing. As the **driver**, you can write your ugly hack
just to show what you want to do, then have your **navigator** improve it.

## The Woes

To be completely honest, sometimes I have a **hard time** getting myself to
**pair** with someone else. I tend to think that I'll go **faster** by myself.
But this is not usually the case, especially when I'm facing **hard problems**.

As a _Senior_ developer sometimes you could actually go **faster** by yourself,
but you would miss out on the opportunity of coaching _Junior_ developers.

If the sessions are **too long**, the navigator will lose interest or get lost
if the _Senior_ developer is driving. The **navigator** should definitely
question **weird-looking code**, but that might slow down the **driver**.

Pairing sessions can be **intense**. After you are done, you need to take a
break before you continue with something else.

The navigator must definitely point out **code smells** and ask the driver to
improve them. If the driver can't, the navigator should improve the smelly code.
That will definitely **slow you down**, but it will produce better code.

The biggest **woe** is that you will produce code at a **slower speed**, but the
code will usually end up with more quality, more coverage and better readability
than if you were programming by yourself.

## Conclusion

If you haven't tried **pair programming** yet, you should definitely give it a
try. After you do, you will likely incorporate it to your weekly routine.

The joys and advantages far outweigh the woes and disadvantages of this
practice.

## Tips

* Pair when you have
[programmer's block](http://c2.com/cgi/wiki?ProgrammersBlock).
* Pair when you have been **stuck** trying to solve a problem for way too long
and haven't made any progress.
* Keep pairing sessions under **two** hours.
* Don't do all the driving during the session, **take turns**.
* Pair with someone with **more experience** than you.
* Pair with someone with **less experience** than you.
* Pair when you are unsure about the solution you just wrote.
* **Be communicative**. Guide the navigator through your thought process.
**Talk** about the alternatives and why you go one way or the other.
* Keep a **post-it** block right next to you. Write down things that could be
improved but not during the session.
* Interrupt only when necessary.
* If you are the navigator, don't be afraid to grab the keyboard to show a
**better alternative** to the code that the driver is writing.
* Put your phone on do not disturb mode.

_[The title of this article was inspired by one of [my favorite chapters](http://home.adelphi.edu/sbloch/class/adages/joy.html) in [The Mythical Man-Month](https://en.wikipedia.org/wiki/The_Mythical_Man-Month) by Fred Brooks]_
