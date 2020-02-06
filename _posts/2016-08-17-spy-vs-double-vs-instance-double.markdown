---
layout: post
title: "Spy vs Double vs Instance Double"
date: 2016-08-17 06:04:00
categories: ["rspec", "ruby"]
author: "mauro-oto"
published: false
---

When writing tests for services, you may sometimes want to use mock objects
instead of real objects. In case you're using ActiveRecord and real
objects, your tests may hit the database and slow down your suite. The
latest release of the [rspec-mocks](https://github.com/rspec/rspec-mocks)
library bundled with [RSpec 3](http://rspec.info) includes at least three
different ways to implement a mock object.

Let's discuss some of the differences between a `spy`, a `double` and an
`instance_double`. First, the `spy`:

```ruby
[1] pry(main)> require 'rspec/mocks/standalone'
=> true
[2] pry(main)> user_spy = spy(User)
=> #<Double User>
[3] pry(main)> spy.whatever_method
=> #<Double (anonymous)>
```

<!--more-->

The `spy` [accepts any method calls](https://relishapp.com/rspec/rspec-mocks/docs/basics/spies)
and always returns itself unless specified. If you need the mock object to raise
if it receives an unexpected method call, you can use a `double` instead:

```ruby
[4] pry(main)> user_double = double(User)
=> #<Double User>
[5] pry(main)> user_double.whatever_method
RSpec::Mocks::MockExpectationError: #<Double User> received unexpected message :whatever_method with (no args)
from /Users/mauro-oto/.rvm/gems/ruby-2.2.1@carbide/gems/rspec-support-3.5.0/lib/rspec/support.rb:87:in block in <module:Support>
```

If you haven't specified that the double can receive a given method, in the case
above `whatever_method`, it'll raise an exception. You can explicitly tell the
double that it can receive such a method and its return value like this:

```ruby
[6] pry(main)> user_double = double(User, whatever_method: nil)
=> #<Double User>
[7] pry(main)> user_double.whatever_method
=> nil
[8] pry(main)> user_double.some_method
RSpec::Mocks::MockExpectationError: #<Double User> received unexpected message :some_method with (no args)
from /Users/mauro-oto/.rvm/gems/ruby-2.2.1@carbide/gems/rspec-support-3.5.0/lib/rspec/support.rb:87:in block in <module:Support>
```

This way, `whatever_method` can be called and `nil` will be returned, which is
the return value we specified. Any other method calls will fail if we
haven't specified them (e.g. `some_method`).

If we want to have even more control over what happens with our mock object, and
disallow arbitrary method creation like `whatever_method` or `some_method`, we
can use a verifying double, which exists since RSpec 3 as `instance_double`:

```ruby
[9] pry(main)> user_verifiable = instance_double(User, whatever_method: nil)
RSpec::Mocks::MockExpectationError: the User class does not implement the instance method: whatever_method
from /Users/mauro-oto/.rvm/gems/ruby-2.2.1@carbide/gems/rspec-support-3.5.0/lib/rspec/support.rb:87:in block in <module:Support>
```

If we try to declare a method which is not implemented by the class of the
mocked instance, it will raise an exception. If we decide to use mock objects in
our tests, instance_doubles provides us with a bit more confidence in our tests
than if we were using spies or regular doubles.

The performance of `instance_double` is slightly worse than `double` or `spy`
because verifying doubles are more complex. The difference between using a
verifying double and a real object is quite significant:

```
Benchmark.ips do |bm|
  bm.report("spy") { spy(User, id: 1) }
  bm.report("double") { double(User, id: 1) }
  bm.report("verifying double") { instance_double(User, id: 1) }
  bm.report("actual object") { User.new(id: 1) }
  bm.report("via factorygirl") { FactoryGirl.build(:user, id: 1) }
  bm.compare!
end

Warming up --------------------------------------
                 spy   402.000  i/100ms
              double   572.000  i/100ms
    verifying double   424.000  i/100ms
       actual object   153.000  i/100ms
     via factorygirl    92.000  i/100ms
Calculating -------------------------------------
                 spy     29.174k (±31.6%) i/s -     55.878k in   5.575866s
              double     21.567k (±37.5%) i/s -     35.464k in   5.599092s
    verifying double      9.418k (±36.4%) i/s -     10.600k in   5.031771s
       actual object      1.226k (±37.3%) i/s -      3.366k in   6.897566s
     via factorygirl      1.037k (±27.4%) i/s -      2.300k in   7.289933s

Comparison:
                 spy:    29174.4 i/s
              double:    21567.0 i/s - same-ish: difference falls within error
    verifying double:     9417.5 i/s - 3.10x slower
       actual object:     1226.1 i/s - 23.79x slower
     via factorygirl:     1036.7 i/s - 28.14x slower
```

If you are testing a service and don't care about testing ActiveRecord callbacks
or database interactions, you will likely be better off using a double. If
you are already using spies or doubles, you may want to use a verifying double
instead. I think the slight performance hit of verifying the object's
implementation is worth it.
