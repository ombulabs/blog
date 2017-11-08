---
layout: post
title:  "Setup Monit notifications on Slack"
date: 2017-11-08 09:30:00
categories: ["monit", "slack"]
author: "luciano"
---

[Monit](https://mmonit.com/monit/) is a powerful tool for monitoring processes on [Unix](https://en.wikipedia.org/wiki/Unix) systems.
Sometimes could be very useful to receive notifications about an specific process from your server in your everyday tool, [Slack](https://slack.com/). This article will show you exactly how to do that.

### Setup Slack

The first part of the Slack setup is really simple, you just need to create a new [Incoming WebHook](https://api.slack.com/incoming-webhooks). You can do that by going to `https://my.slack.com/services/new/incoming-webhook`, select or create a channel, and then click on `Add incoming WebHooks Integration`. Once there you will see a `Webhook URL` that should be similar to this: `https://hooks.slack.com/services/T7W3HFJSO/B7XLPmQAZ/aviXjd5cKdzvzUjfWbCn8oEqr`. You will need that URL in the next step.

The second part requires to create a [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) script that will post Slack messages when you run it.
This is an example of how this file should looks like:

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

Now let's run the script we made to see if it's working (I named it `slack-webhook.sh`)

```
chmod u+x slack-webhook.sh
./slack-webhook.sh
```

Then you will see the message in your Slack channel:

<img src="/blog/assets/images/monit-message.jpg" alt="Monit message" class="full-img">

It looks a bit empty because we didn't set any variable yet (e.g. `$PROCESS`).

### Setup Monit

In this example we are using a [Linux](https://en.wikipedia.org/wiki/Linux) environment running [Ubuntu](https://www.ubuntu.com/) `16.04`.
Also the process that we will be monitoring is [Mosquitto](https://projects.eclipse.org/projects/technology.mosquitto), which is an open source message broker service that uses the MQTT protocol to send and receive messages, typically with IOT (Internet of Things) devices.

You can see if you already have installed Monit by running

```
$ monit --version
This is Monit version 5.16
```

If not you can install it with
```
sudo apt install monit -y
```




Mosquitto conf:

```
# /etc/monit.d/mosquitto.conf

check process mosquitto with pidfile /var/run/mosquitto.pid
  start program = "/etc/init.d/mosquitto start"
  stop program = "/etc/init.d/mosquitto stop"

  if changed pid then exec "/bin/bash -c 'PROCESS=Mosquitto /usr/local/bin/slack.sh'"
  if 1 restart within 1 cycle then exec "/bin/bash -c 'PROCESS=Mosquitto /usr/local/bin/slack-webhook.sh'"
```
