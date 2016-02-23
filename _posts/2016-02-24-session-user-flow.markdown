---
layout: post
title: "Use session variables to optimize your user flow"
date: 2016-02-24 13:37:00
categories: ["ruby", "rails", "sessions"]
author: "schmierkov"
---

Sessions provide you a nice little data storage feature where the application does not need to get the informations directly from the database. So you do not have to persist data in your database and can easily store infos to a user on the fly. This is a nice way to enhance the user experience on your page. Let's say you want to show all users, from a specific area, a new fancy sign up form and the rest only sees the old form. With storing these location informations in a session variable, you do not need to persist this infos in your database.

<!--more-->

That can be pretty handy in many ways, if you think about changing the content of a website based on infos in that session. Handling a lot of session informations can be pretty overwhelming, because you have tons of crazy methods flying around. So my idea was once to stuff all these infos into an object. This way I could test it and do wild things with the data, but the frustration comes as soon as you change your Object stored in your session.

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

  def set_location
    session[:user_location] = Location.new(user_ip)
  end
end
```

The problem is obvious, if you think about that the app has no knowledge of the previously stored object anymore and sends you exceptions. A better way is to think about how and what you want to store in the session. Maybe a specific set of helper or controller methods just for handling the user navigation is enough. With storing some user activities, you can guide or force the user to a specific area of your website.

One example could be a user that has seen all of your pages, but is not willing to sign up or click a specific button. The following could be a first draft for a controller concern to figure out what pages the user has already visited:

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

You don't need much implementation at this point and you can also test it in an [Anonymous Controller](https://relishapp.com/rspec/rspec-rails/docs/controller-specs/anonymous-controller). With some basic helpers like this, you make a lot of things much easier and keep the overview.

Regarding your business ideas and user flow, session variables are a nice way to guide your users, without storing all that informations to the backend or making use of third party data aggregators.

If you know a better way to work with sessions, let me know!
