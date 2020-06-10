---
layout: post
title: "Adding Docker to a Ruby gem"
date: 2015-12-29 13:55:00
reviewed: 2020-03-05 10:00:00
categories: ["docker", "rubygems", "open-source"]
author: "etagwerker"
---

As a maintainer of a few Ruby gems, I have to decide what is accepted and what gets rejected into the gems. The other day someone submitted a [pull request](https://github.com/DatabaseCleaner/database_cleaner/pull/384) to add a Dockerfile to [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner)

I thought it was a good idea, because the current version of DatabaseCleaner requires you to have Postgres, MySQL, Redis, and Mongo up and running before you run `rake`.

Here are the steps:

1. Download the [Docker Toolbox](https://www.docker.com/docker-toolbox), a 176+ MB package.

2. Install the package, which will expand to 400+ MB in your filesystem.

3. In the terminal: `docker-machine start default`

4. Then within your project: `docker-compose up` (before this I had to run `eval "$(docker-machine env default)"` because of [this issue](https://github.com/docker/compose/issues/2180#issuecomment-147766435)). Get ready to wait for a few minutes while it sets up your virtual machine.

5. Finally: `docker-compose run --rm gem`

<!--more-->

Supposedly these steps should start the required services and run the build. I was expecting to watch it pass, but this is what I saw:

```bash
Installing mongo_ext 0.19.3 with native extensions

Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    /usr/local/rvm/rubies/ruby-2.2.2/bin/ruby -r ./siteconf20151224-6-fhvc98.rb extconf.rb
checking for asprintf()... *** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary
libraries and/or headers.  Check the mkmf.log file for more details.  You may
need configuration options.

Provided configuration options:
	--with-opt-dir
	--without-opt-dir
	--with-opt-include
	--without-opt-include=${opt-dir}/include
	--with-opt-lib
	--without-opt-lib=${opt-dir}/lib
	--with-make-prog
	--without-make-prog
	--srcdir=.
	--curdir
	--ruby=/usr/local/rvm/rubies/ruby-2.2.2/bin/$(RUBY_BASE_NAME)
```

If I were to add this contribution, I'd make sure that the `CONTRIBUTE.markdown` lists [Docker](https://www.docker.com) as an _option_ to run the specs, not as the default.
