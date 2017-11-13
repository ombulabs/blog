---
layout: post
title:  "Setup Monit notifications on Slack"
date: 2017-11-13 09:45:00
categories: ["monit", "slack"]
author: "luciano"
---

[Monit](https://mmonit.com/monit/) is a powerful tool for monitoring processes on [Unix](https://en.wikipedia.org/wiki/Unix) systems and sometimes it could be very useful to receive notifications about a specific process from your server to your everyday tool, [Slack](https://slack.com/). This article will show you exactly how to do that.

<!--more-->

In the examples we are using a [Linux](https://en.wikipedia.org/wiki/Linux) environment running [Ubuntu](https://www.ubuntu.com/) `16.04`.
Also the process that we will be monitoring is [Mosquitto](https://projects.eclipse.org/projects/technology.mosquitto), but can be applied to any process just by changing the configuration.

### Setup Slack

As a first step you need to create a new [Incoming WebHook](https://api.slack.com/incoming-webhooks). You can do that by going to `https://my.slack.com/services/new/incoming-webhook`, select or create a channel, and then click on `Add incoming WebHooks Integration`. Then you will see a `Webhook URL` that should be similar to this: `https://hooks.slack.com/services/T7W3HFJSO/B7XLPmQAZ/aviXjd5cKdzvzUjfWbCn8oEqr`. You will need that URL in the next step.

The second part requires you to create a <a href="https://en.wikipedia.org/wiki/Bash_(Unix_shell)"> Bash </a> script that will post Slack messages when you run it.
This is an example of how this file should look like:

```
URL="https://hooks.slack.com/services/T7W3HFJSO/B7XLPmQAZ/aviXjd5cKdzvzUjfWbCn8oEqr" # Slack Webhook URL

PAYLOAD="{
  \"attachments\": [
    {
      \"title\": \"$PROCESS was restarted\",
      \"color\": \"warning\",
      \"mrkdwn_in\": [\"text\"],
      \"fields\": [
        { \"title\": \"Date\", \"value\": \"$MONIT_DATE\", \"short\": true },
        { \"title\": \"Host\", \"value\": \"$MONIT_HOST\", \"short\": true }
      ]
    }
  ]
}"

curl -s -X POST --data-urlencode "payload=$PAYLOAD" $URL
```

If you want to see how to customize the Slack messages you can take a look at the [official documentation](https://api.slack.com/incoming-webhooks#sending_messages).

Before run the script we should add some permissions (I saved it as `slack-webhook.sh` in `/usr/local/bin/`)

```
$ sudo chmod u+x /usr/local/bin/slack-webhook.sh
```

Now let's run it to see if it's working

```
$ /usr/local/bin/slack-webhook.sh
```

If correct, you will see the message in your Slack channel.

<img src="/blog/assets/images/monit-message.png" alt="Monit message">

It looks a bit empty because we didn't set any variables for the message to use (e.g. `$PROCESS`).

### Setup Monit

You can see if you already have installed Monit by running

```
$ monit --version
This is Monit version 5.16
```

If not you can install it with
```
$ sudo apt install monit -y
```

Now that you have Monit installed, you can add the configuration for your process on `/etc/monit/conf.d`


```
check process mosquitto with pidfile /var/run/mosquitto.pid
  start program = "/etc/init.d/mosquitto start"
  stop program = "/etc/init.d/mosquitto stop"

  if changed pid then exec "/bin/bash -c 'PROCESS=Mosquitto /usr/local/bin/slack-webhook.sh'"
  if 1 restart within 1 cycle then exec "/bin/bash -c 'PROCESS=Mosquitto /usr/local/bin/slack-webhook.sh'"
```

This configuration will restart the process in case you stop it manually or if it gets stop by itself. And when that happens it will call the `slack-webhook` script to publish a message in the Slack channel.
You can see a bunch of real-world configuration examples on [this link](https://mmonit.com/wiki/Monit/ConfigurationExamples).

Don't forget to restart Monit after make changes in the configuration.

```
$ monit reload
Reinitializing monit daemon
```

You can easily test this by manually killing the process.

```
$ ps -aux | grep mosquitto
mosquit+ 23073  0.0  0.2  44200  4916 ?        S    19:48   0:00 /usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf

$ kill -9 23073
```

The process will be automatically restarted after a couple of second and you will receive a message in your Slack channel.

<img src="/blog/assets/images/monit-message-2.png" alt="Monit message">

This is just one type of message that you can implement in your Slack team, but you can also do some cooler things with Monit, like sending reports or alerts. You just need to change the configuration files based on that.
