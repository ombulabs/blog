---
layout: post
title: "Consuming SendGrid and Twilio webhooks in Rails"
date: 2019-01-22 10:00:00
categories: ["rails"]
author: "luciano"
---

If you're looking for services that handle the delivery of your emails and SMSs in your app, [SendGrid](https://sendgrid.com/) and [Twilio](https://www.twilio.com/) are some of the most complete options out there.

In this article we are going to focus on a common scenario when using those services: **How can we have a real time status of the emails and text messages that we send from our [Rails](https://rubyonrails.org/) app**.

<!--more-->

Let's say we have a `contacts` table with the following columns: `name`, `email`, `phone_number`, `email_status` and `sms_status`.
When we send an email or SMS with Sendgrid and Twilio, there are a series of events that happen, such as "failed", "delivered", "open" and many more. Here you can see the full list of them:

- [Sendgrid statuses](https://sendgrid.com/blog/the-nine-events-of-email/)
- [Twilio statuses](https://support.twilio.com/hc/en-us/articles/223134347-What-are-the-Possible-SMS-and-MMS-Message-Statuses-and-What-do-They-Mean-)

What we want to achieve is to update our `email_status` and `sms_status` columns when one of these events happen. To do that we'll have to use webhooks.

```
A webhook is an HTTP callback that allows a web application to POST a message to a URL when certain events take place. Often called “Reverse APIs,” Webhooks can be used to receive data in real time, pass it on to another application, or process the data faster than traditional APIs.
```

A clean way to implement that would be to create two separate endpoints, one for each service:

```ruby
# config/routes.rb

post "sendgrid_webhook", to: "sendgrid#webhook"
post "twilio_webhook", to: "twilio#webhook"
```

```ruby
# app/controllers/sendgrid_controller.rb

class SendgridController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
  end
end
```

```ruby
# app/controllers/twilio_controller.rb

class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
  end
end
```

We skipped the `verify_authenticity_token` action so it doesn't raise an `InvalidAuthenticityToken` exception when the endpoint is accessed from outside of our app. But to keep the security in place it's important to add a custom verification so only requests with a specific token can access the endpoints:

```ruby
# config/routes.rb

post "sendgrid_webhook/:token", to: "sendgrid#webhook"
post "twilio_webhook/:token", to: "twilio#webhook"
```

```ruby
# app/controllers/sendgrid_controller.rb

class SendgridController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :valid_webhook_token?

  def webhook
  end

  private

  def valid_webhook_token?
    params[:token] == ENV["SENDGRID_WEBHOOK_TOKEN"]
  end
end
```

```ruby
# app/controllers/twilio_controller.rb

class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :valid_webhook_token?

  def webhook
  end

  private

  def valid_webhook_token?
    params[:token] == ENV["TWILIO_WEBHOOK_TOKEN"]
  end
end
```

You can store the tokens as environment variables or whatever method you use to store your credentials:

```
# .env

SENDGRID_WEBHOOK_TOKEN = 1234567890qwertyuiop
TWILIO_WEBHOOK_TOKEN   = 0987654321poiuytrewq
```

Once we have the two new endpoints we should add their URL to the Sendgrid and Twilio configuration.
For SendGrid that has to be done in their [platform](https://app.sendgrid.com/settings/mail_settings):

<img src="/blog/assets/images/sendgrid_webhook.png" alt="SendGrid webhook configuration">

And for [Twilio](https://github.com/twilio/twilio-ruby) it has to be done using the `status_callback` parameter when we send the text message:

```ruby
def send!
  client = Twilio::REST::Client.new
  client.api.account.messages.create(
     from: "+15005550006",
     to: contact.phone_number,
     body: body,
     status_callback: "https://www.ombulabs.com/twilio_webhook/#{ENV['TWILIO_WEBHOOK_TOKEN']}"
end
```

If everything went well, when we send an email or SMS, the SendGrid and Twilio API will hit our endpoints every time there is a change in the status. So now let's add the logic to update the status in our database:

```ruby
# app/controllers/sendgrid_controller.rb

class SendgridController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :valid_webhook_token?
  before_action :set_contact

  def webhook
    @contact.update_column(:email_status, sendgrid_params[:event])

    render json: {}, status: :ok
  end

  private

  def valid_webhook_token?
    params[:token] == ENV["SENDGRID_WEBHOOK_TOKEN"]
  end

  def set_contact
    @contact = Contact.find_by(email: sendgrid_params[:email])
  end

  def sendgrid_params
    params.require(:_json).first.permit(:email, :event)
  end
end
```

```ruby
# app/controllers/twilio_controller.rb

class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :valid_webhook_token?
  before_action :set_contact

  def webhook
    @contact.update_column(:sms_status, params[:SmsStatus])

    render json: {}, status: :ok
  end

  private

  def valid_webhook_token?
    params[:token] == ENV["TWILIO_WEBHOOK_TOKEN"]
  end

  def set_contact
    @contact = Contact.find_by(email: params[:To])
  end
end
```

And that's pretty much it. I recommend that you put a debugger in the `webhook` method so you can clearly see the parameters you receive so you can tweak it to your needs.

I hope this quick tutorial has been of value to you. Feel free to ask any question in the comments section below.
