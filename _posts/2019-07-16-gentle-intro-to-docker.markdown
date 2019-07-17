---
layout: post
title: "A Gentle Introduction To Docker"
date: 2019-07-16 12:30:00
categories: ["DevOps", "docker", "tutorials"]
author: "rdormer"
---

If you're like I was not too long ago, the DevOps world gives you a chance to experience what most non-developers probably feel like when they read about what we do on a day to day basis - confused, and maybe a little bored and frustrated, with an utter lack of even basic knowledge. It doesn't help that DevOps is rapidly becoming a field of expertise unto itself, or that most of the relevant players seem determined to hide behind vague descriptions like "enterprise platform" and "containerization solution." As a day to day working developer, adding an entire new skillset can be a daunting and intimidating prospect.

<!--more-->

Fear not, though. Getting some basic knowledge is not as hard as it might seem. With just a bit of poking around you can have just enough knowledge to annoy your local DevOps team in no time!

# Familiar Territory

As a Ruby developer, you've undoubtedly used either [RVM](https://rvm.io/) or [rbenv](https://github.com/rbenv/rbenv). We all know why - managing dependencies can be a major pain. Being able to segregate an application into its own environment with its own clean slate consisting of only the dependencies that application has drastically simplifies administration and deployment and reduces aggravation. If you're comfortable with this idea, then you're already familiar with the idea of a [*container*](https://www.docker.com/resources/what-container) - a virtual environment used to separate dependencies and configuration from the rest of the system. It not only saves you a lot of hassle, it lets you run different applications with different dependencies on the same machine without any fireworks or panicky phone calls.

# The next logical step

Of course, other developers using other languages and environments long ago figured out that they would like to have the same thing for themselves. In some cases they came up with their own language specific solution to this problem. At the end of the day, though, what you really want is a way to create virtual containers that is language agnostic. Eons ago, when mainframes and workstations roamed the earth, Unix developers came up with the concept of the chroot jail.

Although mainly intended for use as a security measure, it inadvertently accomplishes the same sort of dependency isolation we're talking about here, in a less manageable fashion.  Since it's not specifically meant for deploying applications and managing dependencies, using it in an RVM-ish fashion would be a fairly painful exercise. What would be *really* nice if you could create such environments easily - from a template, for instance - and had a suite of tools to manage them.

# And we widen to reveal...

Enter [Docker](http://docker.com).  It started life as a cloud computing platform, but after a few years, its creators open sourced it. Open sourcing it did what open sourcing does - changed things - and now we have the modern Docker you've been hearing so much about. But Docker does more than just generalizing the abilities of a language specific manager to any executable application - it brings a number of new abilities to the table. You can migrate a container to an entirely new host, replicate a single container any arbitrary number of times, and encapsulate complex services in an easy to run, atomic fashion. A full listing could (and has) fill a book.  You get the idea.

# Show me

Glad you asked.  The simplest way to get started with Docker is to [install it](https://docs.docker.com/install/) - you can save yourself some confusion (and creating an un-needed account) by perusing the [binaries repository](https://download.docker.com/) as well.  Installation can be a bit of a process, so be ready for that.  Once the smoke has cleared and you're done gritting your teeth, open up a command line and try:

``docker run hello-world``

Neat, if a little underwhelming.  Read the output, by the way - it has a decent explanation of how Docker works in general - your command downloaded an image, then created a container for the image, ran some commands and captured their output for you.  Note that an image and a container are two separate concepts - you can have one image, but have it running in as many different containers as you want.  The image is the template used to create containers, much like a class is a template used to created individual objects of that class.

How about something that's a little more fun to play with?  Run:

``docker run -it ubuntu bash``

Just like before, Docker will download an image - this time, the well known Linux variant Ubuntu - and then create a container to run it in.  Note the extra argument that we added at the end, though - a command that will be executed within the container created from the downloaded image.  It's the same basic syntax (and idea) that you would use to run a command remotely with ssh.  In this case, it'll give you a nice, interactive shell that lets you poke around in your container.  The ``-it`` bit is a pair of command line options that allocate a terminal and tell Docker that you want to actually interact with the container.  Now try:

``cd /``

And notice that you're *not* in your own root directory, but the container's.  Try as you might, you can't get out to your host file system - the container is isolated from the rest of your OS.  The only way to get out is to exit the shell. Try creating a few files, then exiting the container and running it again. You'll see that they're gone - any changes you make to the container are lost once you exit.  This is very useful for creating temporary, disposable development and testing environments!

To really drive home the difference between an image and a container, try running the Ubuntu command above in a few terminals at once.  Then try making some modifications, like creating or deleting some files.  If you look in the other running Ubuntu containers, you'll see that your changes are not reflected in them.  They're isolated, remember?  You can see a list of all the containers you're running by executing:

``docker ps``

And what about that hello-world image that we started out with?  It would be nice if we could open that up and take a look at it's guts, don't you think?  There's one complication, though: it doesn't include a shell like Bash or sh that can run to get an interactive session going.  Wouldn't it be nice if we could mount the image as a file system and use another image with the tools we need to poke around?  We can!

To do that, we're going to download the [Busybox](https://busybox.net) image, an image that rolls a bunch of standard Linux utilities into a single executable, described as the "swiss army knife" of Docker images.  Once we mount the container on ``/tmp/dockerimage`` we'll open a shell that will let us inspect the mounted image.  Start by running:

``docker run -it -v=hello-world:/tmp/dockerimage busybox sh``

If everything goes smoothly, you'll end up with a shell prompt running within a hello-world container - poke around and see what you can find.  As an added bonus, if you'd like to see a dump of a whole bunch of information about the image, try:

``docker image inspect hello-world``

At this point you're starting to build up a nice little collection of images.  You can see them with:

``docker image ls``

Obviously, we've only barely scratched the surface of what Docker can do.  But, as you can see, you don't need to be intimidated at all - once you know a little bit about it, it's actually pretty straight forward.

Next time, we'll take things to the next level and explore how to make your own Docker images.
