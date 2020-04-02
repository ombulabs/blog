---
layout: post
title: "Quick and easy admin options"
date: 2019-03-18 09:00:00
reviewed: 2020-03-05 10:00:00
categories: ["security", "gems", "rails"]
author: "rdormer"
---

One of the first complications that most webapps of any complexity will run into is the need for privileged users who can do things that normal users can't or shouldn't be able to do. Before too long, you're headed towards writing your very own administrative interface. This is not only extra work, but can be tricky to do without compromising the security of the application you're administering. Most [Rails](http://rubyonrails.org) developers will be familiar with this story, and Rails being Rails, it turns out that there are a couple of good options for extending your existing applications with a pre-generated, customizable admin console.

<!--more-->

Specifically, you have two good choices in the form of [ActiveAdmin](https://activeadmin.info) and [Administrate](https://administrate-prototype.herokuapp.com/getting_started). Both are implemented as engines, distributed as Gems, and make it dead easy to quickly develop an admin console.

### Ignore that console behind the curtain

Before we get too far into the particulars of each option, let's take a quick moment to discuss some basic design and security considerations. Let's talk about where your administrative interface is going to live.

It's a common - and often unthinking - choice to implement an admin interface as an extension to the functionality of the existing application. Code for administrative functions then winds up promiscuously intermixed with code meant to run at lower privilege levels, cheek and jowl with code being run by non-administrative users. The reasoning is often that it's just easier that way, and it does make a certain amount of sense to have code meant to administer elements of a system closely coupled to them.

While there's an exception to every rule, generally speaking this particular style of administrative interface is a security breach just waiting to happen. In much the same way that it's a bad idea to accept input from users without a certain amount of filtering and pre-processing, it's probably not a good idea to put code that has the power to alter the state of the application anywhere near the same codepath executed by un-privileged users. At the very least, this particular pattern is going to place a greater demand on whatever testing infrastructure you have in place - if you're going to put sensitive code in the same application that any old user can use, you'd better make sure you've done a thorough job of testing it to make sure that end users won't make any "interesting" discoveries.

A sensible alternative to this potential mess is to separate your administrative functions. This can be done to either a specific area of the existing application, or even better yet, to a stand alone application. In addition to isolating sensitive code to a completely separate code base, you can take additional security measures not related to the code at all, such as placing the admin functions inside a VPN.

### Enter our contenders

Since they're both implemented as Rails engines, to a large extent using either Administrate or ActiveAdmin will make the choice for you - you'll start out leaning heavily towards the separate application camp. I make a note of that because, if you really want to just create an administrative overlay on your existing application, then neither one of these options will help you much.

### ActiveAdmin

If you're a big fan of DSLs, then take a look at [ActiveAdmin](https://activeadmin.info).  The core pattern behind it is a straightforward [DSL](https://martinfowler.com/books/dsl.html) that lets you register a resource, and then add it's fields to a largely pre-defined interface.

Between the two options, ActiveAdmin generally takes less work to stand up a running application, and provides much better filtering and sorting out of the box. Tastes may vary, but the UI also looks more polished. However, I've found customizing the interface with additional javascript and UI flair like inline editing and dropdown menus to be more difficult. That said, it's definitely a solid option, and one that you should lean towards if you just want to put up an admin app and things like filtering and sorting are really important for your use case.  There's also a considerable incumbent advantage - ActiveAdmin has been under development for about nine years as of publication, making it less likely to contain security compromising surprises.

### Administrate

If you prefer to stick to plain old Ruby and use Rails conventions, then [Administrate](https://administrate-prototype.herokuapp.com/getting_started) may be what you're looking for. In keeping with general Rails philosophy, it adheres to a set of conventions to provide a pretty standard, "pre-canned" administrative application with minimal configuration needed. However, if you need to extend or alter the standard functionality, then you can override the gem provided controllers, views, and styling elements using generators provided by the gem. Just generate whatever you need to customize (views, controller actions), either for the app as a whole or for a specific resource, and edit away. This makes Administrate more straightforward to customize if you have some more specific requirements. This is good in general, and also helps to make up for a rougher and less fully featured default interface.

One drawback to be aware of is that, as of the time of writing this article, Administrate does not support namespaced models.  Generating an install against an application with them will output a warning about this, and a console that makes no reference to any of the namespaced models. Depending on how you've organized your application, that could potentially be a show stopper.

It's also a newer development effort - as their [github page](https://github.com/thoughtbot/administrate) currently states:

**Administrate is still pre-1.0, and there may be occasional breaking changes to the API**

### Either way...

Either option is significantly quicker and easier than rolling your own administrative interface from scratch. They'll probably be more secure as well, since the cardinal rule of application security is **don't roll your own**. Security flaws in either gem are more likely to be discovered and fixed, benefitting your own security. Since both are engines, they can be integrated with an existing application easily. In both cases, it's not much more work at all to just put them in their own, separate application. As with all tools, do your research and pick which one suits your particular use case and environment best.
