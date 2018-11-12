---
layout: post
title:  "Tips for Writing Fast Rails: Part 2"
date: 2018-11-12 12:10:00
categories: ["rails", "performance"]
author: "luciano"
---

Some time ago we wrote a couple of [Tips for Writing Fast Rails](https://www.ombulabs.com/blog/performance/rails/writing-fast-rails.html). Now we decided to continue sharing our knowledge on this topic so here is the part two!

<!--more-->

A common mistake that we usually see in [Rails](https://rubyonrails.org/) applications is the lack of use of [ActiveRecord::Calculations](https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html), which is the rails way to do math operations in the database. This can affect the performance of your application because otherwise you'll have to do it in the code. That means to initialize [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html) objects and iterate through them, which is not the faster way to do it, specially when you have a ton of records in your database.

To show the difference in execution time between doing the math in the database vs in the code we'll be using [benchmark-ips](https://github.com/evanphx/benchmark-ips). Here are a few examples:

Note: The table used for the examples has thousands of records, so the difference should be quite noticeable.

[ActiveRecord::Calculations#sum](https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html#method-i-sum) vs [Enumerable#sum](https://apidock.com/rails/Enumerable/sum):
```ruby
Benchmark.ips do |x|
  x.report("SQL sum") do
    Loan.sum(:balance)
  end

  x.report("Ruby sum") do
    Loan.sum(&:balance)
    # Same as: Loan.all.map { |loan| loan.balance }.sum
  end

  x.compare!
end

# Comparison:
#            SQL sum:        7.89 i/s
#           Ruby sum:        0.03 i/s - 209.85x  slower
```

[ActiveRecord::Calculations#maximum](https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html#method-i-maximum) vs [Enumerable#max](https://apidock.com/ruby/Enumerable/max):
```ruby
Benchmark.ips do |x|
  x.report("SQL max") do
    Loan.maximum(:amount)
  end

  x.report("Ruby max") do
    Loan.pluck(:amount).max
  end

  x.compare!
end

# Comparison:
#              SQL max:      516.0 i/s
#             Ruby max:        0.6 i/s - 859.88x  slower
```

As you can see, changing your query a little bit can have significantly improvements in performance. Don't forget to take a look a the `ActiveRecord::Calculations` [documentation](https://api.rubyonrails.org/classes/ActiveRecord/Calculations.html) to see all the available methods.
