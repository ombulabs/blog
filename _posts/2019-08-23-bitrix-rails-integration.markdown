---
layout: post
title: "How to Integrate Bitrix24 with your Rails app: Part 1"
date: 2019-08-23 16:00:00
categories: ["rails", "bitrix"]
author: "luciano"
published: false
---

In a recent project for [Ombu Labs](https://www.ombulabs.com), we had to integrate [Bitrix24](https://www.bitrix24.com/) (the tool that the client was using to administrate their business) with the [Rails](https://rubyonrails.org/) application that we were building for a client.

The goal of this integration was to sync data between the Rails app and the [Bitrix CRM](https://www.bitrix24.com/features/crm.php). Basically we wanted to pull data from Bitrix every time there was a change (i.e. [Lead](https://www.bitrix24.com/features/lead-management.php) was created/updated). We also wanted to sync the other way around, push changes to Bitrix every time something changed on the Rails side.

<!--more-->

We are going to break this process into two different articles. This one will cover the steps that you need to do to connect both sides. And part 2 will cover how to push and pull data using [webhooks](https://training.bitrix24.com/rest_help/rest_sum/webhooks.php).

## App Authorization
The [Bitrix API](https://training.bitrix24.com/rest_help/index.php) uses [OAuth 2.0](https://oauth.net/2/) for authorization. We'll show you one of the ways you can use it in Rails:

### Create a new endpoint

We'll need a new endpoint that the Bitrix application (that we're going to create in the next step) can [redirect to](https://oauth.net/2/grant-types/authorization-code/).

```ruby
# config/routes.rb

get "bitrix/connect", to: "bitrix#connect"
```

```ruby
# app/controllers/bitrix_controller.rb

class BitrixController < ApplicationController
  def connect
  end
end
```

### Create a new application in Bitrix
You can login in to your Bitrix account and go to the Applications menu to add a new application.

<img src="/blog/assets/images/bitrix-app.png" alt="bitrix-app">

You should check the "Available as script only" option and also the sections you want to have access to (i.e. CRM). At the bottom of the form you'll have to plug in the URL of the endpoint that we created in the previous step (`bitrix#connect`).

Once you save it you'll have a new application with an `Application ID` and `Application key`.
I recommend you store those credentials as environment variables in Rails so you can use them later.

### Connection

Fortunately there is a [Ruby gem](https://github.com/nononoy/bitrix24_cloud_api) which makes it easy to interact with the Bitrix API.

Go ahead and add it to your Gemfile, and then run `bundle install`

`gem 'bitrix24_cloud_api'`

Once you have the gem installed you can create a simple class to handle the connection.

```ruby
# app/services/bitrix_service.rb

class BitrixService
  def initialize
    @app_id = ENV["BITRIX_APP_ID"] # Application ID of your Bitrix app
    @app_key = ENV["BITRIX_APP_KEY"] # Application key of your Bitrix app
    @endpoint = "my.bitrix24.com" # Replace 'my' with your subdomain
    @redirect_uri = "http://123.ngrok.io/bitrix/connect" # It should match the URL that you put in your Bitrix app
  end

  def client
    params = {
      app_id: @app_id,
      app_key: @app_key,
      endpoint: @endpoint,
      redirect_uri: @redirect_uri
    }

    Bitrix24CloudApi::Client.new(params)
  end
end
```

You can now go to the `rails console` and run the following statement to generate the Bitrix authorization URL:

```ruby
# rails console

BitrixService.new.client.authorize_url
```

If you did everything right it should return a URL similar to `https://my.bitrix24.com/oauth/authorize?client_id=xxxxx&redirect_uri=xxxxx&response_type=code`.
You can paste that in the browser and it will redirect you to the `/bitrix/connect` endpoint that you previously added, with an extra `code` parameter. You'll probably see an error because we didn't add any logic to our endpoint yet.

We want to get an [access_token](https://tools.ietf.org/html/rfc6749#page-10) and `refresh_token` in exchange for the `code` param that we received, so let's add some logic to do that:

```ruby
# app/controllers/bitrix_controller.rb

class BitrixController < ApplicationController
  def connect
    client = BitrixService.new.client
    tokens = client.get_access_token(params[:code])

    render json: { tokens: tokens }
  end
end
```

Go back to the generated URL in the browser and now you should see a JSON response with the tokens.

Once you have the `access_token` you can start performing requests to the Bitrix API.

```ruby
# rails console

client = Bitrix24CloudApi::Client.new(access_token: "abc123456", endpoint: "my.bitrix24.com" )
client.leads
```

The only thing to consider here is that the `access_token` has an expiration date of 1 hour. So it won't work if you need to use it after 60 minutes.
That's where the `refresh_token` comes into place. You should store the ` refresh_token` (from the JSON response) as an environment variable so you can always use it to generate a new `access_token`.

If we tweak our class a bit we can now have support for it:

```ruby
# app/services/bitrix_service.rb

class BitrixService
  def initialize(access_token = nil)
    @access_token = access_token

    # ...
  end

  def client
    params = if @access_token.present?
               { endpoint: @endpoint, access_token: @access_token }
             else
               {
                app_id: @app_id,
                app_key: @app_key,
                endpoint: @endpoint,
                redirect_uri: @redirect_uri
               }
             end

    Bitrix24CloudApi::Client.new(params)
  end

  def generate_access_token
    client.refresh_token(ENV["BITRIX_REFRESH_TOKEN"])[:access_token]
  end
end
```

You can try it by yourself by running:

```ruby
# rails console

access_token = BitrixService.new.generate_access_token
client = BitrixService.new(access_token).client

client.leads
```

You can use the code above every time you want to establish a connection. The only way that the [refresh_token](https://training.bitrix24.com/rest_help/oauth/refreshing.php) expires is if you don't send requests for more than 30 days.

### Conclusion
This first part showed you how you can connect your Rails app with your Bitrix account. Stay tuned for part 2 where we are going to see how to push and pull data from Bitrix using webhooks.
