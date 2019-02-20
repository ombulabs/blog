---
layout: post
title:  "Refactoring with Design Patterns - The State Pattern"
date: 2019-02-20 10:00:00
categories: ["code-refactor", "design-patterns"]
author: "cleiviane"
---

In this series of [code refactoring](https://www.ombulabs.com/blog/tags/code-refactor) posts we are discussing how design patterns can be used to make our [Ruby](https://www.ruby-lang.org/en/) code beautiful, maintainable and clean.

Today I want to talk about a pattern that can be very useful when we need to control the flow of a set of events of our objects: *[The State Pattern](http://wiki.c2.com/?StatePattern)* a.k.a *Finite State Machine*.

As a developer it is common to see objects changing their state. At the beginning managing the state of an object can be as simple as having some boolean attributes where you can check if the object is in state A or B. But when the complexity increases you can end up with a number of states that are difficult to manage without breaking the [SOLID principles](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod). That is where we can implement the elegant solution provided by the State Pattern.

<!--more-->

## The State Pattern

According to the [Refactoring Guru](https://refactoring.guru/design-patterns/state): <strong>_"The main idea of the State pattern is that, at any given moment, there’s a finite number of states which an object can be in. Within any unique state, the program behaves differently, and the program can be switched from one state to another instantaneously."_</strong>

Think of the solution as a [finite sate machine](https://brilliant.org/wiki/finite-state-machines/) where you can control your objects making sure that they can be in only one state at a time, so the objects will transition from one state to another to perform a set of different actions.

Here at Ombulabs a good example of when we need to use state pattern is in one of our products, [Ombushop](https://www.ombushop.com). It's an e-commerce platform where users can create their customized store and sell products online.

One of the objects we need to handle is the `Order` (of course), which will change its state several times until we can say that the order is complete. The order is first created when the buyer adds a product to the cart, then if the buyer is in the checkout page the order will change to checkout state, when the payment is done we need to change the order to pending and that way the order will move from one state to another until it's completed or canceled. This is a very typical scenario where we can use the state.

<!--more-->

## Show me the code

State machines are usually implemented with lots of conditional operators that select the appropriate behavior depending on the current state of the object. In ruby we could do something like:

```ruby
class Order < ApplicationRecord
  def change_state
    case state
    when "cart"
      state = "checkout"
    when "checkout"
      state = "paying"
    when "paying"
      state = "pending"
    when "pending"
      state = "completed"
    when "completed"
      state = "delivered"
    else
      state = "cart"
    end
  end
end
```

Doesn't feel good, right? What if you need to do some validations before allowing to change to the next state? What if I need to go back to a previous state? The code would be more complex and the `change_state` method would clearly have more than one responsibility. We can solve this problem by applying the state pattern.

There are a few gems that can help us with this job, but I recommend the [AASM gem](https://github.com/aasm/aasm) because it's easy to understand and implement, we just need to include the gem in our model and start to set our states:

Back to Ombushop's code, using the aasm we can refactor the `Order` model like this:

```ruby
class Order < ApplicationRecord
  include AASM

  aasm(column: 'state') do
    state :cart, initial: true
    state :checkout, before_enter: :update_totals!
    state :pending
    state :completed, after_enter: :finalize!
    state :delivered
    state :canceled
    state :resumed,
    state :returned,
    state :paying

    event :next do
      transitions from: :cart, to: :checkout
      transitions from: :checkout, to: :paying
    end

    event :pending do
      transitions from: [:checkout, :paying], to: :pending
    end

    event :payment_received do
      transitions from: :pending, to: :paid
    end

    event :cancel do
      transitions to: :canceled
    end

    # ... several other events here
  end
```

First of all we need to tell aasm what is the column used to save the state. Then we need to add all possible states (remember that we need to have a finite number of states) and set which one is the initial state. Then in the `event` blocks we can start to define the flow between the states. It is as simple as that.

As you probably noticed we can also define callback functions to be called if we need to do any action before or after the object transitions to some state.

AASS also provides some useful methods such like:

```ruby
  order = Order.new
  order.cart? # => true
  order.pending
  order.pending? # => true
  order.may_complete? # => true
  order.complete
  order.completed? # => true
```

This can help us to manage states in our code more efficiently without creating a lot of extra methods. It also makes it easier to add a new state if you ever need in the future.

## Conclusion
Handling the states of an object is a hard job by itself. In this article we saw how applying the state pattern can make our life better offering a solution to this. Next time that you have an object that behaves differently depending on its current state, the number of states is finite and the object changes of state frequently remember of this important design pattern.

I hope that this article has being useful for you. We will keep talking about principles and patterns here in our blog, so stay tuned!
