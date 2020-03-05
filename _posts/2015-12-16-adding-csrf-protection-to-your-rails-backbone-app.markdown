---
layout: post
title: "Adding Csrf-Protection to your Rails-Backbone App"
date: 2015-12-16 03:55:00
reviewed: 2020-03-05 10:00:00
categories: ["rails", "backbone", "security"]
author: "schmierkov"
---

When integrating [Backbone.js](http://backbonejs.org) in your [Rails](http://rubyonrails.org) App, you might face the problem of the inability to verify the CSRF-Token.

The CSRF Protection secures your app with a token. Rails makes sure that the person who is interacting with your app is someone who started a session in your site, not some random attacker from another site. So you should not turn it off, unless you know what you are doing.

For more information on this Topic, check out the [Rails Security Guide](http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf).

This problem occurs as soon as you are trying to send form data, without the CSRF-Token provided by Rails.

```ruby
Started POST "/products" for 127.0.0.1 at 2015-12-16 10:06:05 -0300
Processing by ProductsController#create as JSON
  Parameters: {"product"=>{"name"=>"foo"}}
WARNING: Can't verify CSRF token authenticity
...
Completed 302 Found in 7.6ms (ActiveRecord: 0.8ms)
```

After this request, Rails will terminate your session and you will have to login again.

This problem is caused by your Backbone.js application, which is sending the data directly to the backend without providing the CSRF-Token.

To solve this problem you need to add the token to your Backbone request. One of the simplest solutions I came across is the following by [Anton Shuvalov](https://github.com/shuvalov-anton/backbone-rails-sync).

```javascript
// https://github.com/shuvalov-anton/backbone-rails-sync
Backbone._sync = Backbone.sync;
Backbone.sync = function(method, model, options) {
  if (!options.noCSRF) {
    var beforeSend = options.beforeSend;

    // Set X-CSRF-Token HTTP header
    options.beforeSend = function(xhr) {
      var token = $('meta[name="csrf-token"]').attr('content');
      if (token) { xhr.setRequestHeader('X-CSRF-Token', token); }
      if (beforeSend) { return beforeSend.apply(this, arguments); }
    };
  }
  return Backbone._sync(method, model, options);
};
```

It grabs the CSRF-Token provided in the meta tags of your Rails application and sets it for the request header field `X-CSRF-Token`.

After adding this to the Backbone code, it works as expected.

```ruby
Started POST "/products" for 127.0.0.1 at 2015-12-16 10:08:29 -0300
Processing by ProductsController#create as JSON
  Parameters: {"product"=>{"name"=>"foo"}}
...
Completed 200 OK in 40.6ms (Views: 0.6ms | ActiveRecord: 10.3ms)
```
