---
layout: post
title: "Use session variables to optimize your user flow"
date: 2016-04-22 8:37:00
categories: ["ruby", "rails", "sessions"]
author: "schmierkov"
published: false
---

Sessions provide you a nice little data storage feature where the application does not need to get the information directly from the database. So you do not have to persist data in your database and can easily store info about the user on the fly. This is a nice way to enhance the user experience on your page.

Let's say that you want to show some users a new fancy sign up form and the rest the old form. If you store the version of the sign up form in a session variable, you don't need to persist this info in your database.

<!--more-->

That can be pretty handy in many ways, if you think about changing the content of a website based on the session's information. Handling a lot of session data can be pretty confusing, since the session is just a simple storage. That basically means that you have to organize your way of working with sessions.

I once had the idea to put all this information into an object. This way I could test it and do wild things with the data, but the frustration comes as soon as you change your Object stored in your session.

Basically this is what you should **NOT** do:

```ruby
class Location
  def initialize(ip)
    @location = location_request(ip)  
  end

  def city
    @location.city
  end
  ...
end
class ApplicationController < ActionController::Base
  before_action :set_location

  def set_location(user_ip)
    session[:user_location] = Location.new(user_ip)
  end
end
```

As soon as you later remove the location class and you are still trying to access `session[:user_location]`, your App will raise the following exception:

```
ActionDispatch::Session::SessionRestoreError

Session contains objects whose class definition isn't available.
Remember to require the classes for all objects kept in the session.
(Original exception: uninitialized constant MyController::Location [NameError])
```

The problem is at first not very obvious. The app has no knowledge of the previously stored class anymore.

A better way is to not store complex objects or classes in the session. Think about how and what you want to store in the session and keep the data structure simple. Maybe a specific set of helper or controller methods just for handling the user navigation is enough. You can guide or force the user to a specific area of your website using the stored session information.

One example could be a user that has seen all of your pages, but is not willing to sign up or click a specific button. You could write a concern like this one to figure out what pages the user has already visited:

```ruby
before_action :store_path

def store_path
  session[:visited_paths] ||= []
  if session[:visited_paths].exclude?(request.path)
    session[:visited_paths].push(request.path)
  end
end

def visited?(path)
  session[:visited_paths].include?(path)
end
```

You can keep it simple at this point and you can also test it in an [Anonymous Controller](https://relishapp.com/rspec/rspec-rails/docs/controller-specs/anonymous-controller). With some basic helpers like this, you could make a lot of things much easier and keep the code maintainable.

Session variables are a great way to test your business ideas and user flow. They are a good way to guide your users without storing a lot of information in the database or using third party services.

Keep in mind that the cookie session size is limited to 4kb, in case you want to store a lot of data. Check also this [StackOverflow question](http://stackoverflow.com/questions/9473808/cookie-overflow-in-rails-application) for a workaround to this issue.

If you know a better way to work with sessions, let me know!
