---
layout: post
title:  "Service Objects: beyond fat models and skinny controllers"
date: 2019-09-04 12:00:00
categories: ["rails"]
author: "cleiviane"
published: false
---

Service Objects are a controversial idea for several different reasons: some developers like to use them, others like to use similar patterns, and some think that they are just unnecessary because they prefer fat models.  

Here at Ombu Labs we like to use service objects whenever we can, we think it's a great way to keep our controllers skinny.

In this post I would like to discuss my idea about service objects and why it's adopted by our team.

<!--more-->

## What is a Service Object?

A Service is a stateless object that encapsulates a set of steps and usually has a single purpose. It's a great resource to decompose fat Active Record models while still keeping the controllers thin, because we take away some validations which don't belong to a model nor a controller.  

Recently we added a new feature in our productized service [FastRuby.io](https://fastruby.io) , to verify if the visitor is eligible for a discount or not. For that validation we need to check if the discount is inside a 24 hour window, connect to an external API service to check if the discount code is valid and then decide to show or hide the discounted price.

This is not something we should do in a model. A model is a representation of a plain ruby object that can be instantiated. In this case we are not going to instantiate any validator model, it's a good thing to avoid instantiating objects whenever it's possible.

So if we can't use a model for this task, should we leave it in the controller? Let's try that:

```ruby
class PageController < ApplicationController

  def index
    @show_discount = false

    if params[:discount_code].present?
      discount = DiscountCode.find_by(discount_code: params[:discount_code])

      if discount.present?
        @show_discount = discount.created_at > 24.hours.ago
      else
        DiscountCode.create(discount_code: params[:discount_code])
        @show_discount = true
      end

      if @show_discount
        client = ExternalApi::Client.new
        @show_discount = client.validate(discount_code)
      end
    end
  end
end
```

The problem with this approach is that we just fattened our controller, adding 13 more lines to it. Also, we can ask ourselves: is it really the responsibility of the controller to check if the discount code is valid or not? I would say this is the kind of thing we should create a service for:

```ruby
class DiscountValidator
  def self.validate(discount_code)
    valid_discount = false

    discount = DiscountCode.find_by(discount_code: discount_code)

    if discount.present?
      valid_discount = discount.created_at > 24.hours.ago
    else
      DiscountCode.create(discount_code: discount_code)
      valid_discount = true
    end

    if valid_discount
      client = ExternalApi::Client.new(api_key: MY_API_KEY)
      valid_discount = client.validate(discount_code)
    end

    valid_discount
  end
end
```

Now in our controller we just need to call the new service:

```ruby
class PageController < ApplicationController

  def index
    @show_discount = false

    if params[:discount_code].present?
      @show_discount = DiscountValidator.validate(params[:discount_code])
    end
  end
end
```

It looks much better, right? With these changes we are refactoring our code so when we look at our controller we know exactly what it does without knowing how the discount validation is done. The code is cleaner and easier to read.

An important thing to note here is the convention for the names of the class and method. The name of the service class needs to describe the kind of action that is going to be performed, and with that you realize that we are creating specialized classes that hold a single action in your application. This is also why the method name needs to tell your service to do this action. Other examples of method names could be: `call`, `execute`, `run`.


## Conclusion

Service objects are a great resource to help improve the readability of your code and keep things with only one responsibility.  What about you, do you like to use service objects? Or do you prefer to use some other pattern instead? I would love to see your thoughts in the comments section!
