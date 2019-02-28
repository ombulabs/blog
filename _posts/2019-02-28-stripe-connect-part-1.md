---
layout: post
title: "Implementing Stripe Connect in Rails: Part 1"
date: 2019-02-28 10:00:00
categories: ["rails", "stripe"]
author: "luciano"
---

In a recent project for [Ombu Labs](https://www.ombulabs.com), we were looking for a payment solution that allows users of our platform to easily start accepting online payments while at the same time allowing us to collect a fee from each transaction they receive.
That's where [Stripe Connect](https://stripe.com/connect) came into place.

<!--more-->

To make things easier to follow we will break this topic in two articles:
- Part 1: How to allow your users to connect a Stripe account in order to accept payments.
- Part 2: How your users can receive payments in their Stripe account and how you can receive a fee for each transaction into your own Stripe account.


## Part 1: How to allow your users to connect a Stripe account in order to accept payments

One of the first things you have to decide is which [Stripe account type](https://stripe.com/docs/connect/accounts) you want for your users. Each option serves better for different needs. For this article we'll be using [Express accounts](https://stripe.com/docs/connect/express-accounts) (the following steps can change a bit if you decide to use a different account type).

### Workflow
The user experience for connecting a Stripe account should look something like this:
- User clicks on a "Connect with Stripe" button.
- User is redirected to a Stripe page to setup their account.
- Once the setup is completed, the user is redirected to an endpoint that we previously selected (`stripe#connect`).
- Once in that endpoint, we make a POST request to Stripe to finish the connection of the account.
- If the response was successful, we save in our database the `stripe_user_id`  that we received and then we show a success message to the user.

### Create your own Stripe account
If you don't have a Stripe account yet, you can create one [here](https://dashboard.stripe.com/register?redirect=%2Fconnect%2Foverview).
For now you'll only need it to access your [settings](https://dashboard.stripe.com/account/applications/settings) and [credentials](https://dashboard.stripe.com/account/apikeys).

### Step 1: Add a "Connect with Stripe" button
Users should have a [link](https://stripe.com/docs/connect/express-accounts#integrating-oauth) to connect their Stripe account.
For the UI we can use one of the [designed buttons](https://stripe.com/newsroom/brand-assets) that Stripe offers.

```ruby
# app/views/users/settings.html.erb

<%= link_to image_tag("stripe_button.png"), stripe_button_link %>
```

```ruby
# app/helpers/users_helper.rb

def stripe_button_link
  stripe_url = "https://connect.stripe.com/express/oauth/authorize"
  redirect_uri = stripe_connect_url
  client_id = ENV["STRIPE_CLIENT_ID"]

  "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"
end
```

### Step 2: Add an endpoint to be redirected after the account setup

In the URL for the "Connect with Stripe" button we specified that after the user completes the Stripe account setup, it will [redirect](https://stripe.com/docs/connect/express-accounts#redirected) to `stripe_connect_url`, so let's create that endpoint.

You should also include the full link to this endpoint in your [settings](https://dashboard.stripe.com/account/applications/settings).

```ruby
# routes.rb

get "stripe/connect", to: "stripe#connect", as: :stripe_connect
```

```ruby
# app/controllers/stripe_controller.rb

class StripeController < ApplicationController
  def connect
  end
end
```

### Step 3: Make a POST request to Stripe to finish the account setup
At this point we have the necessary params to make the final [request](https://stripe.com/docs/connect/express-accounts#complete-express-connection) to complete the account connection. We're using [httparty](https://github.com/jnunemaker/httparty) for that, but you can do it with [Net::HTTP
](https://ruby-doc.org/stdlib-2.6.1/libdoc/net/http/rdoc/Net/HTTP.html) too.

```ruby
# app/controllers/stripe_controller.rb

class StripeController < ApplicationController
  def connect
    response = HTTParty.post("https://connect.stripe.com/oauth/token",
      query: {
        client_secret: ENV["STRIPE_SECRET_KEY"],
        code: params[:code],
        grant_type: "authorization_code"
      }
    )
  end
end
```
### Step 4: Add `stripe_user_id` to our database

If the response was successful we'll receive a `stripe_user_id` which represents the Stripe account that we just connected. We should store that in our database so we know what's the Stripe Account of each `User` object.

```ruby
# db/migrate/20190227164333_add_stripe_user_id_to_users.rb

class AddStripeUserIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_user_id, :string
  end
end
```

### Step 5: Save the `stripe_user_id` and show a message to the user

Finally, we redirect with a success message and we also update the User with the `stripe_user_id` that we received.

```ruby
# app/controllers/stripe_controller.rb

class StripeController < ApplicationController
  def connect
    response = HTTParty.post("https://connect.stripe.com/oauth/token",
      query: {
        client_secret: ENV["STRIPE_SECRET_KEY"],
        code: params[:code],
        grant_type: "authorization_code"
      }
    )

    if response.parsed_response.key?("error")
      redirect_to user_settings_path(user),
        notice: response.parsed_response["error_description"]
    else
      stripe_user_id = response.parsed_response["stripe_user_id"]
      @user.update_attribute(:stripe_user_id, stripe_user_id)

      redirect_to user_settings_path(user),
        notice: 'User successfully connected with Stripe!'
    end
  end
end
```

Now that we have a `stripe_user_id` we can show a message instead of the "Connect with Stripe" button:

```ruby
# app/views/users/settings.html.erb

<% if @user.stripe_user_id %>
  Connected with Stripe
<% else %>
  <%= link_to image_tag("stripe_button.png"), stripe_button_link %>
<% end %>
```

### Bonus

Stripe allows your connected accounts to have access to a [dashboard](https://stripe.com/docs/connect/express-dashboard) where they can see their balance and some of the information they entered during setup. You can include a link to it so your users can access it.

```ruby
# app/views/users/settings.html.erb

<% if @user.stripe_user_id %>
  <%= link_to "Go to Stripe Dashboard", stripe_dashboard_path(@user.id) %>
<% end %>
```

```ruby
# routes.rb

get "stripe/dashboard/:user_id", to: "stripe#dashboard", as: :stripe_dashboard
```

You'll need to install the [stripe gem](https://github.com/stripe/stripe-ruby) if you haven't installed it yet.

```ruby
# app/controllers/stripe_controller.rb

class StripeController < ApplicationController
  def dashboard
    account = Stripe::Account.retrieve(@user.stripe_user_id)
    login_links = account.login_links.create

    redirect_to login_links.url
  end
end
```

### Conclusion

This first post was to show how to connect Stripe accounts to your users. Stay tuned for the next part where we'll be talking about the payments, charges, fees and more!
