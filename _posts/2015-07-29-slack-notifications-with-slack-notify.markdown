---
layout: post
title: "Slack Notifications With Slack-Notify Gem"
date: 2015-07-29 17:40:00
categories: ["ruby"]
author: "mauro-oto"
---

We have been using Slack at Ombulabs for a while now after switching from
HipChat, and haven't looked back. It looks and feels much better than any other
available platform of its kind. Slack provides
[WebHooks](https://api.slack.com/incoming-webhooks), which you can use to post
messages to your team's channels.

We use [Solano CI](https://www.solanolabs.com) (formerly Tddium) for our
automated builds, and we would get e-mails whenever a build passed or failed,
but we wanted to be notified in our Slack channels. Enter the
[slack-notify](https://github.com/sosedoff/slack-notify) gem, which makes
notifying Slack using Ruby a breeze.

To get started, first
[set up an incoming webhook](https://my.slack.com/services/new/incoming-webhook).

Once that's done, you can create the Rake task which Solano can run when
the build has finished running:

```ruby
  def current_branch
    `git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-`.strip
  end

  task :post_build_hook do
    require 'slack-notify'

    client = SlackNotify::Client.new(channel: "#your-channel",
                                     webhook_url: 'https://hooks.slack.com/services/your-hook',
                                     username: "Solano CI",
                                     icon_emoji: ":shipit:")
    msg = "_#{current_branch}_ *#{ENV['TDDIUM_BUILD_STATUS']}*!"
    msg << " Check build details at: "
    msg << "http://#{ENV['TDDIUM_API_SERVER']}/1/reports/#{ENV['TDDIUM_SESSION_ID']}"
    client.notify(msg)
  end
```

This will let #your-channel know the branch for which the build either passed,
failed or errored, and the link with the build report.

We have also set up deployment notifications, so whenever someone deploys to
production, the Slack channel is notified.

```ruby
```

There are many different use cases, just make sure not to spam your team with
too many notifications, and you will probably want to set up a channel dedicated
solely to notifications if you are a bigger team.
