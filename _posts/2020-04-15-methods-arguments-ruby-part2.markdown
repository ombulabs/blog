---
layout: post
title: "Exploring Method Arguments in Ruby: Part 2"
date: 2020-04-15 09:00:00
categories: [ruby, learning]
author: arieljuod
---

In [the first part of this series](https://www.ombulabs.com/blog/ruby/learning/method-s-arguments-pt-1.html "Exploring Method Arguments in Ruby: Part 1 - The Lean Software Boutique") we talked about positional arguments, but there are more types. In this second part we'll talk about keyword arguments.

Positional and keyword arguments share a lot of characteristics so we'll split this article into similar sections, but there are some key differences we'll touch on in each section.

<!--more-->

## Keyword Arguments

The main difference between positional and keyword arguments is that the former have to be passed in a specific order while keyword arguments can be used in any order using a different syntax.

## Required Keyword Arguments

These keyword arguments are required when calling a method. If the method defines required parameters you have to provide an argument for each key. The syntax when defining required keyword arguments for a method is similar to positional arguments except you need a colon at the end of the parameter name. Like this:

```ruby
def foo(arg1:)
  puts "arg1 is: #{arg1.inspect}"
end
```

And you have to add key value pairs matching the keys defined in the method definition when calling the method. Keys MUST be symbols.

```ruby
foo(arg1: 1) # you have to specify the key / parameter name
# => arg1 is: 1

foo(:arg1 => 1) # you can use the old hash syntax
# => arg1 is: 1

foo
# ArgumentError (missing keyword: arg1)

foo(1) # notice ruby knows that it expects 0 positinal arguments but requires keyword arguments
# ArgumentError (wrong number of arguments (given 1, expected 0; required keyword: arg1))

```

You can assign the same key multiple times and the last one will be the value for that parameter. You'll see a warning though (but no error):

```ruby
foo(arg1: 1, arg1: 2)
# => warning: key :arg1 is duplicated and overwritten on line X
#    arg1 is: 2
```

Up until Ruby 2.6 you can wrap keyword arguments with curly braces with no issues. Ruby will deconstruct the hash into keyword arguments transparently:

```ruby
# ruby 2.6.3
foo({arg1: 1})
# => arg1 is: 1
```

But this WON'T be allowed on ruby 3 and will raise an **ArgumentError** exception ([official announcement](https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/)). If you use this with ruby 2.7 you'll see a deprecation warning:

```ruby
# ruby 2.7
foo({arg1: 1})
# => warning: Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
#    arg1 is: 1
```

Keyword arguments are not really useful in that simple example, but the benefit is clearer when we start adding more parameters.

```ruby
def foo(arg1:, arg2:, arg3:, arg4:) # and more and more...
```

You can call that method with the parameters in any order:

```ruby
foo(arg1: 'bar', arg3: 'baz', arg2: 'biz', arg4: 'buz')

# is the same as
foo(arg1: 'bar', arg2: 'biz', arg3: 'baz', arg4: 'buz')

# or
foo(arg4: 'buz', arg2: 'biz', arg1: 'bar', arg3: 'baz')
```

## Optional Keyword Arguments

Similar to optional positional arguments, we can provide a default value and let the user override that if needed. The syntax is similar to required keyword arguments but with the default value like this:

```ruby
def foo(arg1: 'default value')
  puts "arg1 is: #{arg1.inspect}"
end

foo(arg1: 1)
# => arg1 is: 1

foo
# => arg1 is: default value

foo(1) # this is not assigned to the keyword argument, this is a positional argument!
# ArgumentError (wrong number of arguments (given 1, expected 0))
```

We can have as many as we want, just like the required parameters.

## Combining Required and Optional Keyword Arguments

Now we can combine both required and optional arguments in one method definition:

```ruby
def foo(arg1:, arg2: 'default value')
  puts "arg1 es: #{arg1.inspect}"
  puts "arg2 es: #{arg2.inspect}"
end

foo(arg1: 1)
# => arg1 is: 1
#    arg2 is: default value

foo(arg1: 1, arg2: 2)
# => arg1 is: 1
#    arg2 is: 2

foo(arg2: 2, arg1: 1) # order doesn't matter
# => arg1 is: 1
#    arg2 is: 2

```

You can mix required and optional keyword arguments order, it's not a problem in this case.

```ruby
def foo(arg1:, arg2: 'default value', arg3:, arg4: 'default for 4')
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
  puts "arg3 is: #{arg3.inspect}"
  puts "arg4 is: #{arg4.inspect}"
end

foo(arg1: 1, arg2: 2, arg3: 3, arg4: 4)
# => arg1 is: 1
#    arg2 is: 2
#    arg3 is: 3
#    arg4 is: 4

foo(arg1: 1, arg3: 2)
# => arg1 is: 1
#    arg2 is: default value
#    arg3 is: 2
#    arg4 is: default for 4
```

## Optional Arguments Based on other Arguments

Like positional arguments, default value for keyword arguments can use the value of other arguments:

```ruby
def foo(arg1:, arg2: arg1 * 2)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo(arg1: 1)
# => arg1 is: 1
#    arg2 is: 2

foo(arg1: 1, arg2: 3)
# => arg1 is: 1
#    arg2 is: 3
```

This can also depend on the value of optional arguments:

```ruby
def foo(arg1: 1, arg2: arg1 * 2)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo
# => arg1 is: 1
#    arg2 is: 2

foo(arg1: 2)
# => arg1 is: 2
#    arg2 is: 4
```

The only requirement is that the arguments used in the default value were previously defined. This won't work:

```ruby
def foo(arg1: arg2 * 2, arg2: 1)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo
# NameError (undefined local variable or method `arg2' for main:Object)
```

But changing the order will:

```ruby
def foo(arg2: 1, arg1: arg2 * 2)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo
# => arg1 is: 2
#    arg2 is: 1
```

> Notice keyword arguments can be used in any order **when calling** a method but you have to order them as needed **on the definition** of the method if you want to use arguments to calculate the default value of other arguments!

You can use operations and method calls for the default value, just like default values for optional positional arguments.

```ruby
def two_times(x)
  x * 2
end

def foo(arg1: 1, arg2: two_times(arg1))
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo
# => arg1 is: 1
#    arg2 is: 2

foo(arg1: 5)
# => arg1 is: 5
#    arg2 is: 10 # it's multiplying 5, not 1, it uses our value, not te default one

foo(arg2: 6) # you don't need to use a value for arg1 to use a value for arg2!
# => arg1 is: 1
#    arg2 is: 6

foo(arg1: 5, arg2: 6)
# => arg1 is: 5
#    arg2 is: 6 # we are actually overriding that multiplication
```

## Variable Arguments

This type of optional keyword arguments don't have a default value. They exist only if assigned and you can access them using a special hash of arguments. We need to use this special syntax with the \*\* operator (double splat operator) in front of the parameter name:

```ruby
def foo(**kargs) # it's common to name it kargs
  puts "kargs is: #{kargs.inspect}"
end
```

Now you can add as many keyword arguments as you want:

```ruby
foo(some_key: 1)
# => kargs is: {:some_key=>1}

foo(one_key:1, another_key: 2)
# => kargs is: {:one_key=>1, :another_key=>2}
```

You can combine these arguments with required and optional arguments too:

```ruby
def foo(arg1:, arg2: 'default value', **kargs)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
  puts "kargs is: #{kargs.inspect}"
end

foo(arg1: 1, arg2: 2, arg3: 3, arg4: 4)
# => arg1 is: 1
#    arg2 is: 2
#    kargs is: {:arg3=>3, :arg4=>4}

foo(arg1: 1, arg2: 2, arg3: 3)
# => arg1 is: 1
#    arg2 is: 2
#    kargs is: {arg3: 3}

foo(arg1: 1, arg2: 2)
# => arg1 is: 1
#    arg2 is: 2
#    kargs is: {}

foo(arg1: 1)
# => arg1 is: 1
#    arg2 is: default value
#    kargs is: {}
```

Notice that "kargs" is always a hash. You usually deconstruct the hash (using the double splat operator) or use it as is as a hash or to call another method:

```ruby
def bar(arg2:, **kargs)
  puts "arg2 in bar is: #{arg2.inspect}"
  puts "kargs in bar is: #{kargs.inspect}"
end

def foo(arg1:, **kargs)
  puts "arg1 in foo is: #{arg1.inspect}"
  puts "kargs in foo is: #{kargs.inspect}"

  # we need the ** (double splat operator) again so ruby deconstructs the
  # hash into different keyword arguments
  # if we don't do this it will show a
  # deprecation warning in ruby 2.7 and
  # raise an error in ruby 3
  bar(**kargs)
end

foo(arg1: 1, arg2: 2, arg3: 3, arg4: 4)
# => arg1 in foo is: 1
#    kargs in foo is: {arg2: 2, arg3: 3, arg4: 4}
#    arg2 in bar is: {arg2: 2}
#    kargs in bar is: {arg3: 3, arg4: 4}
```

> This special parameter must always be used after the other keyword arguments. This is not allowed:

```ruby
def foo(**kargs, arg1:)
```

## Combining Positional and Keyword Arguments

You can combine these two types of arguments; the only requirement is that positional arguments go first, then keyword arguments.

```ruby
def foo(arg1, arg2 = 'default for 2', *args, arg3:, arg4: 'default for 4', **kargs)
```

In that generic example we have:

- arg1 => required by position
- arg2 => optional by position
- args => optional by position, variable
- arg3 => required by key
- arg4 => optional by key
- kargs => optional by key, variable

## Conclusion

Now we can have methods with a lot of flexibility combining both positional and keyword arguments and making some of them required and some optional, but we are not finished yet.

Ruby gives us even more options that we will cover on the next post in this series. We will also analyze a few common Rails methods to see how they use different types of arguments so that we can put everything together with practical examples.
