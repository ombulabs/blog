---
layout: post
title:  "How to Git push with blocked ports"
date: 2015-06-28 18:29:00
categories: ["git", "github"]
author: etagwerker
published: false
---

Often times I find myself working out of a coffee shop with a **terrible Internet connection**. We have a nice office at [OmbuLabs](https://es.foursquare.com/v/ombushop-hq/52f0e47311d25da04d101b62) but there is still that *Je ne sais quoi* at coffee shops.

The cool thing about [Git](https://git-scm.com/) is that you can `git commit` all your changes while enjoying a cup of coffee and `git push` later (when you're back at home with a decent connection)

But what if you want to `git push` from the coffee shop? Sometimes the only ports that are open are port 80 (HTTP) and 443 (HTTPS).

<!--more-->

If your Git remote repository supports HTTPS, you can easily push to it by following these steps:

    git remote add origin-https https://github.com/DatabaseCleaner/database_cleaner.git
    git push origin-https master

A Git repository can have as many remote repositories as you want, so I like to keep `origin` and `origin-https` to `git push` whenever I want.

You will have to enter your username and password to authenticate with Github.

    $ git push origin-https master
    Username for 'https://github.com': etagwerker
    Password for 'https://etagwerker@github.com':
    Everything up-to-date

Now you can `git push` even on shitty Internet connections.
