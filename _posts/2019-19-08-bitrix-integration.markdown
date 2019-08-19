---
layout: post
title: "Integrate Bitrix24 to a Rails app: Part 1"
date: 2019-19-08 10:00:00
categories: ["rails", "bitrix"]
author: "luciano"
---

In a recent project for [Ombu Labs](https://www.ombulabs.com), we had to integrate [Bitrix24](https://www.bitrix24.com/) (the tool that the client was using to administrate their business) to the [Rails](https://rubyonrails.org/) app that we were building for them.

<!--more-->

The goal of this integration was to sync data between the Rails app and the [Bitrix CRM](https://www.bitrix24.com/features/crm.php). Basically we wanted to pull data from Bitrix every time there was a change (i.e. [Lead](https://www.bitrix24.com/features/lead-management.php) was created/updated). And we also wanted to do it the other way around, push changes to Bitrix every time something changes in the Rails side.

We are going to break this process into two different articles. This one will cover the steps that you need to connect both sides. And the Part 2 will cover how to push and pull data using [webhooks](https://training.bitrix24.com/rest_help/rest_sum/webhooks.php).

## App Authorization
The [Bitrix API](https://training.bitrix24.com/rest_help/index.php) uses the [OAuth 2.0](https://oauth.net/2/) authorization protocol. In order to make use of it you have to:

### Create a new endpoint

We need a new endpoint so the Bitrix application that we're going to create in the next step can redirect during the authorization process.

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
You can login into your Bitrix account and go to the Applications menu. There you'll see a button to [add a new application](https://siu.bitrix24.com/marketplace/local/).

(screenshot)

You should check the "Available as script only" option and also the sections you want to have access to (i.e. CRM). And at the end of the form you'll have to put the URL of the endpoint that we created in the previous step.
Once you do that you click on the Save button. Now you should have a new application with an `Application ID` and `Application key`.

I recommend you to store those credentials as environment variables in Rails so you can later use them in a secure way.

### Install the bitrix24_cloud_api gem

Fortunately there is a [Ruby gem](https://github.com/nononoy/bitrix24_cloud_api) that makes it easier to interact with the Bitrix API.

Go ahead and add it to your Gemfile, and then run `bundle`

`gem 'bitrix24_cloud_api'`

Once you have the gem installed you can create a simple class to handle the connection.

```ruby
# app/services/bitrix_service.rb

class BitrixService
  def initialize
    @app_id = ENV["APP_ID"] # Application ID of your Bitrix app
    @app_key = ENV["APP_KEY"] # Application key of your Bitrix app
    @endpoint = "my.bitrix24.com" # Replace 'my' with your subdomain
    @redirect_uri = "http://123.ngrok.io/bitrix/connect" # It should match the URL that you put in your Bitrix application.
  end

  def client
    params = {
      app_id: @app_id,
      app_key: @app_key,
      endpoint: @endpoint,
      redirect_uri: @redirect_uri}

    Bitrix24CloudApi::Client.new(params)
  end
end
```

You can now go to the `rails console` and run these two lines to generate the Bitrix authorization URL
```ruby
client = BitrixService.new.client
client.authorize_url
```

If you paste the output URL in the browser it should redirect you the the `/bitrix/connect` endpoint that you added with a `code` param.
Right now that endpoint is empty so let's go ahead and add some logic to handle the incoming params

```ruby
# app/controllers/bitrix_controller.rb

class BitrixController < ApplicationController
  def connect
    client = BitrixService.new.client

    if params[:code]
      refresh_token = client.get_access_token(params[:code])[:refresh_token]

      render json: { refresh_token: refresh_token }
    end
  end
end
```
