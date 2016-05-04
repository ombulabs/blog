---
layout: post
title: "Set up and run Hubot without using Heroku"
date: 2016-01-29 11:16:00
categories: ["hubot", "linux"]
author: "mauro-oto"
---

[Hubot](https://hubot.github.com) makes it incredibly easy to setup on a Heroku
server, by taking advantage of its Procfile support. Simply running
`git push heroku master` deploys the app and starts it.

When it comes to deploying to your own Linux server, given that
`foreman` doesn't really like background processes (see:
[ddollar/foreman#65](https://github.com/ddollar/foreman/issues/65)), you need to
use something like `monit`, `systemd` or `tmux` to better manage your Hubot
process.

<!--more-->

If you don't already have your own Hubot repository, you can easily create one.
The easiest way is using the hubot generator:

```bash
npm install -g yo generator-hubot
```

Run the generator in a folder of your choosing:

```bash
$ mkdir myhubot
$ cd myhubot
$ yo hubot
```

Go through the steps the generator takes you, and when you're done, initialize a
Git repository and push it to Github or your preferred Git server.

Go ahead and choose where you want to run your Hubot from and SSH into your
instance (we used an AWS EC2 instance). Once in it, you can clone your Hubot
repository, or if you prefer, create a Capistrano recipe and deploy it.  

As I mentioned before, you could run `foreman start` now to check that your bot
is working, but you can't leave it running in the background out-of-the-box, as
`foreman` is not friendly to background processes.

You can work around this by leaving `foreman` itself running in a dettached tmux
session:

```bash
$ tmux new -s hubot
$ cd /path/to/hubot
$ foreman start
<Ctrl-b>-d
```

This is **not the best way to do it**, as the process could end unexpectedly and
it won't come up again. This forces you to re-attach to the session or kill it
and restart Hubot manually.

The best way is to use either a `systemd` service or `monit`. For a `monit`
example, check out
[this gist](https://gist.github.com/philcryer/d391b72511f4b69cece3).

In our case, we use `systemd`, which allows us to start it by running
`sudo service hubot start`. To do this, create the following service file:

```bash
; Hubot systemd service unit file
; Place in e.g. `/etc/systemd/system/hubot.service`, then
; `systemctl daemon-reload` and `service hubot start`.

[Unit]
Description=Hubot
Requires=network.target
After=network.target

[Service]
Type=simple
WorkingDirectory=/path/to/hubot
User=deployer

Restart=always
RestartSec=10

ExecStart=/bin/bash -a -c 'cd /path/to/hubot && source .env && /bin/hubot --adapter slack'

[Install]
WantedBy=multi-user.target
```

Finally, you can run `systemctl daemon-reload` and then
`sudo service hubot start`. Any changes you make to the bot can be obtained
using `git pull origin master` and then restarting the Hubot service
(`service hubot restart`), or by using Capistrano if you wrote the deploy recipe
for it.

Hubot is a nice addition to your team, and if you use the Slack
integration, you can use it for cool stuff like deploying via your CI server,
or simple things like getting pictures of pugs delivered to your channel!

![pug me](https://cloud.githubusercontent.com/assets/17584/12687311/c6f97cc6-c6ad-11e5-91b6-4e0c861aa196.png)
