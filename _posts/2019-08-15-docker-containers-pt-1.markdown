---
layout: post
title: "Roll your own Docker containers (part 1)"
date: 2019-08-21 12:30:00
reviewed: 2020-03-05 10:00:00
categories: ["devops", "docker", "tutorials"]
author: "rdormer"
---

In my [last article](https://www.ombulabs.com/blog/devops/docker/tutorials/gentle-intro-to-docker.html), I gave a brief tour of what Docker is, and basic usage. Once you've got your feet under you with basic usage, you'll reach the point where you want to start making your own containers. You'll certainly need to know how to roll your own if you want to use Docker in your own infrastructure.

<!--more-->

## Container basics

Broadly speaking, there are two types of Docker images - *base images*, and images that are built on top of them. Most of the time, when you're making an image of your own, you'll be inheriting from a base (or parent) image, and tweaking it by layering changes over top of it.  Layering is exactly what you're doing, by the way - as you execute commands and copy data into a container, all of the changes you're making are written to a *writable layer* (also known as the *container layer*). There's a lot more to this particular subject - see [storage drivers](https://docs.docker.com/storage/storagedriver/) and [volumes](https://docs.docker.com/storage/volumes/) for a lot more information.

## Starting the easy way

You'll start by creating a Dockerfile, the configuration file containing the commands that Docker will use to build your image.  [The first command](https://docs.docker.com/engine/reference/builder/#from) is `From`:

`FROM debian`

Which specifies that you'll be building your image on top of [Debian](https://hub.docker.com/_/debian).  Usually, the image that you'll be building will be, at least partially, a copy of some application that you're running.  You can create an image of this application by putting your Dockerfile in a directory containing a clean installation of your application. All of the commands in your Dockerfile will be relative to this directory, which Docker calls the *context*.  Add the [following command](https://docs.docker.com/engine/reference/builder/#copy) after the `FROM` command:

`COPY . /myapp`

If you have [any other commands that need to be run](https://docs.docker.com/engine/reference/builder/#run), you can use the `RUN` command.  Let's use it to install [RVM](https://rvm.io/):

`RUN apt-get update`
`RUN apt-get install curl`
`RUN curl -sSL https://get.rvm.io | bash -s stable --ruby`

To review, your Dockerfile looks like this:

`FROM debian`
`RUN apt-get update`
`RUN apt-get install curl`
`RUN curl -sSL https://get.rvm.io | bash -s stable --ruby`
`COPY . /myapp`

Run this command:

`docker build -t myfirstcontainer .`

And you're on your way.  The base image will be downloaded, changes will be written to it, and the whole mess will be sent to the Docker daemon.  Run `docker image ls` to see your newly created image, and then run it with `docker run myfirstcontainer`.  Note that what you've put in `RUN` statements won't actually execute within the container until you run it.  This makes perfect sense, since you can't run a command within the context of a container until one is created, which is exactly what the run command will do.

Building your images on top of a base image is a fast and relatively easy way to make images for your own specific needs. But sometimes, you'll really want more control. Next time, we'll take a look at rolling images from scratch.
