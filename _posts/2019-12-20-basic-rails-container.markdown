---
layout: post
title: "Creatings A Legacy Rails Container"
date: 2019-12-20 12:30:00
categories: ["devops", "docker", "tutorials"]
author: "rdormer"
---

Here at OmbuLabs, we do a lot of work with older versions of Ruby and Rails.  Recently, I've been taking a look at [Docker](https://www.ombulabs.com/blog/tags/docker), the virtual container platform, to see how it might help us manage the often idiosyncratic setup that applications we work with might require.

As I've noted [before](https://www.ombulabs.com/blog/devops/docker/tutorials/docker-containers-pt-2.html), setting up your own containers from scratch is usually a bad idea.  Wherever you can, start with a [base image](https://hub.docker.com/search?category=base&source=verified&type=image) to save you a *lot* of time.  We'll start with the Ubuntu base image:

```
FROM ubuntu
RUN apt-get update
```

It's a good idea to update the apt-get database when you build your container, since the base image is essentially frozen in time and you may want newer packages as they become available.  You might think it's not a big deal if you're using a container to run a legacy application like we are here, but keep in mind that packages also routinely receive security updates, and you'll definitely want those.

Next, you'll want to install the dependencies that Rails requires to run.  This won't just be Ruby - it'll be everything required to build Ruby and any native extensions you end up using.  At the time of writing, the minimal set of dependencies you'll need to install are:

`RUN apt-get -y install ruby ruby-dev make gcc git zlib1g-dev`

Note the -y, which is there to preemptively answer "yes" to installation questions from apt-get.  You'll need to do that for any apt-get install commands to prevent the Docker build from bombing with an error.  It's also [recommended](https://docs.docker.com/develop/develop-images/dockerfile_best-practices) that you run the update and install commands in the same RUN command, which gives us:

`RUN apt-get update && apt-get -y install ruby ruby-dev make gcc git zlib1g-dev`

Next up comes a database.  In this case, we'll use Postgres:

`RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql libpq-dev`

This is the standard RUN command, followed by setting the DEBIAN_FRONTEND environment variable.  The Postgres installation process, by default, will prompt for responses to several multi-choice questions, more complex than the simple yes/no questions that are automatically answered by the -y switch.  Setting the DEBIAN_FRONTEND environment variable will prevent this from also ending your Docker build.

From here on out, it's the usual process.  Install Rails (in my case, [version 4.2](https://guides.rubyonrails.org/v4.2/)) and (optionally), copy a directory into your image.  If you elect to copy a directory, keep in mind that Docker will not allow you to copy anything from outside of the directory that your Dockefile is located in.

Taken all together:

```
FROM ubuntu
RUN apt-get update && apt-get install -y ruby ruby-dev make gcc git zlib1g-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql libpq-dev
RUN gem install rails --version=4.2
COPY ./blog srv
```

If you're in the business of working with one or more legacy applications, give some serious thought to containerizing them with Docker if you haven't already.  It's one of the easiest ways around to breathe new life into an old app.
