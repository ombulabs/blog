---
layout: post
title: "Roll your own Docker containers (part 2)"
date: 2019-10-11 12:30:00
categories: ["DevOps", "docker", "tutorials"]
author: "rdormer"
---

The [last time](https://www.ombulabs.com/blog/devops/docker/tutorials/docker-containers-pt-1.html) we looked at Docker, we looked at the most basic and easy version of using it - building an image from a base image, a parent, and then layering additions and changes on top of it.  With a carefully chosen base image, this can be an extremely flexible and relatively straightforward way of getting an image up and running in a [container](https://www.docker.com/resources/what-container).

But what if you don't need or want a base image?  Sometimes, you need the utmost control over the contents of your image, either because of security concerns or perhaps because of storage or memory constraints.  Sometimes what you really need is to add your own dependencies and absolutely nothing else to a blank image.  You do this by creating your own base image, from scratch.

Like before, you'll start with a [Dockerfile](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).  The first step when building your own image from scratch is, appropriately enough, to start with:

`FROM scratch`

Technically, you don't *have* to include this line - you can just skip the `FROM` statement entirely, if you want, but it's probably better to include it for the sake of clarity.  Either way, this will create an image that is essentially empty.  An empty image isn't especially useful, so here comes the tedious part: you're going to have to copy dependencies into this container, one by one.  And by "dependencies", I mean OS level requirements.  

Pulling in OS dependencies from scratch can be rather complicated, to put it mildly.  The one break you get here is that you won't have to build or copy [your own kernel](https://stackoverflow.com/questions/43383276/how-does-docker-run-a-linux-kernel-under-macos-host) in to your image.  The price of this lucky break is that no matter what OS you're running Docker on, you'll need to build your software on Linux.  The work around here if you're not on Linux is to build your software in another Docker container, and then copy it over.  A quick one liner to get you started:

`docker run --rm -it -v $PWD:/build ubuntu:16.04`

This will open an Ubuntu container for you to use as your build platform.  Bear in mind though that any changes you make will disappear if you shut down the container, so don't do that until you're done building everything and you've safely copied it to your host OS. Linux users can just build binaries as they normally would.  Either way, you'll probably want to build static executables. Otherwise, you'll have to chase down potentially hundreds of library dependencies.

You can try to compile Ruby as a static executable, if you're feeling [up for a challenge](https://github.com/phusion/traveling-ruby#why_precompiled_binary_difficult).  It should be noted that since the "end user" in this case will be guaranteed to have a completely uniform environment, it may well be worth taking on this particular challenge.  Alternatively, you can make the tradeoff of using an older Ruby version and using something like [Traveling Ruby](https://github.com/phusion/traveling-ruby) to save yourself the effort.

Once you have either your statically linked Linux binaries or binaries plus their entourage of libraries, you'll put them in the same directory as your dockerfile, and copy them into your image, as usual:

`ADD mystaticbinary`

If all of this is starting to sound like an awful lot of effort, that's because it certainly can be.  Astute readers may be wondering why you'd use a potentially outdated Ruby version if security is a concern, or why you'd use relatively bloated binaries if memory is a concern.  Both of these are also good reasons *not* to roll your own image from scratch. With the huge [library of base images](https://hub.docker.com/) that Docker has to choose from, it's almost certainly the case that you can find something minimal enough for your needs.  Creating your own image from scratch is something that you'll really only want to do if you've exhausted all of your other options.
