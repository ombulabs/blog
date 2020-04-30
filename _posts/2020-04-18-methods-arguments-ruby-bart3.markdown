---
layout: post
title: "Exploring Method Arguments in Ruby: Part 3"
date: 2020-04-18 09:00:00
categories: [ruby, learning]
author: arieljuod
---

In [the first](https://www.ombulabs.com/blog/ruby/learning/method-s-arguments-pt-1.html "Exploring Method Arguments in Ruby: Part 1 - The Lean Software Boutique") and [second](https://www.ombulabs.com/blog/ruby/learning/methods-arguments-ruby-part2.html) parts of this series we talked about positional and keyword arguments, but we still have some extra options so that our methods can do anything we want.

In this final part we are going to explore blocks, array decomposition, partially applied methods and a few syntax tricks. We'll also study a few known methods to understand how eveything is used in real world applications.

<!--more-->

## Block Argument

Sometimes it's not enough to pass a variable to a method, sometimes we need to provide some customized code to modify what a method does. We can provide a block when calling a method following a special block syntax (really common in ruby):

```ruby
def foo(&my_block)
  my_block.call
end

foo do
  puts 'hi'
end
# => hi

foo do
  puts 2 + 2
end
# => 4
```

You can pass arguments to the block call:

```ruby
def foo(&my_block)
  my_block.call('hi')
end

foo do |message|
  puts message
end
# => hi
```

The block argument can be combined with the rest of the argument types, but there can be only one block argument and it must be the last one.

```ruby
def foo(arg1, &block)
  puts "arg1 is: #{arg1.inspect}"
  block.call(arg1.reverse)
end

foo('arg1') do |message|
  puts message
end
# => arg1 is: arg1
#    1gra
```

### Implicit Block Argument

If you are just calling the block and you don't need it as a variable, you can use an implicit block and a special `yield` statement to call it.

```ruby
def foo(arg1)
  puts "arg1 is: #{arg1.inspect}"
  yield(arg1.reverse)
end

foo('arg1') do |message|
  puts message
end
# => arg1 is: arg1
#    1gra
```

> So, as we see, we can always pass a block argument **even if a method doesn't actually use it!**.

When we write a method, we may need to know whether the user provided a block or not. If the block parameter is explicit we can just check that it isn't nil, but we have a safer way of checking that also works with implicit blocks:

```ruby
def foo(arg1)
  if block_given?
    yield(arg1)
  else
    puts "you have to provide a block"
  end
end

foo('arg1')
# => you have to provide a block

foo('arg1') do |message|
  puts message
end
# => arg1
```

## Array Deconstruction

Sometimes we may have a method that accepts an array as one of the arguments. Usually we just use a normal argument and extract the values inside the method:

```ruby
def foo(my_arr)
  el1, el2 = my_arr
  # ...
end

foo([1,2])
```

But we can do that when defining parameters so we don't need that line and we get the benefit of being able to use the array elements when defining the default value of other arguments:

```ruby
def foo((el1, el2), arg2 = el1 * 5)
  puts el1
  puts el2
  puts arg2
end

foo([1, 2])
# => 1
#    2
#    5

foo([1, 2], 'something')
# => 1
#    2
#    something
```

> If our array includes more elements than the expected, the rest are discarded!

## Ignoring Arguments

If you want to accept any number of arguments but not use them (imagine you are implementing a replacement of a library you are using and you have to respect the method calls but don't really need the arguments) you can use the `*` and `**` operators with no name for the parameter:

```ruby
def foo(*, **)
  puts 'I ignore everything'
end

foo(1, 2, 'three', more_things: 'ignored')
# => I ignore everything
```

## Arguments Delegation

If you are writing a wrapper around another method, you usually need to accept the same arguments, do something, and then call the original method. If we need to use exactly the same arguments and we don't need them for our extra code, we can use a special argument for delegation introduced in Ruby 2.7 (the `...` operator):

```ruby
def foo(...)
  bar(...)
end

def bar(arg1, arg2)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo(1, 2)
# => arg1 is: 1
#    arg2 is: 2
```

## Partially Applied Methods

We may have a process that does multiple calls to one method using mostly the same arguments and only changes some of them. To refactor those calls we can use the concept of function (or method) generators. The idea is to get our method, apply only some arguments, and then have a new method that requires only the rest of the arguments that were not applied yet.

Let's say we have a generic method to multiply two numbers:

```ruby
def multi(num1, num2)
  puts num1 * num2
end
```

Now let's imagine we want to have a method that multiplies by 3 because we are using that a lot. We can reuse that original method and only apply the number 3 using the `curry` method on the method object:

```ruby
multi3 = method(:multi).curry.call(3)
#        ^ we use method(:mutli) to get the method object
#          instead of calling the method
```

Now we can use that new method (it's actually a Proc) to have different numbers multipied by 3:

```ruby
multi3.call(2) # => 6
multi3.call(5) # => 15

# .() is a shorthand for .call()
multi3.(10) # => 30
```

## Case Study 1: link_to

Let's analyze Rails' `link_to` method.

```ruby
# all arguments are optional, it just prints an empty "A" tag
def link_to(name = nil, options = nil, html_options = nil, &block)
  # when we call this method with a block, our first argument is
  # not the name for the link, it's actually the options, and the
  # second argument is actually the html_options for the link
  html_options, options, name = options, name, block if block_given?
  
  # it sets default options here instead of using a default value for
  # the parameter because the previous line changes what each
  # parameter actually is depending if there a block given
  options ||= {}

  html_options = convert_options_to_data_attributes(options, html_options)

  url = url_for(options)
  html_options["href".freeze] ||= url

  # it's a wrapper over 'content_tag' method
  content_tag("a".freeze, name || url, html_options, &block)
end
```

## Case Study 2: pluralize

Let's analyize another example: the `pluralize` helper method:

```ruby
# it requires a count and a word in singular

# we have two ways to set the 'plural' of the word:
# - using the third positional argument
# - using the 'plural' keyword argument
# the keyword argument uses the positional as the default value!

# if we leave the plural form empty, it will use the I18n module
# to infere the plural form, we can also include a 'locale' keyword
# argument but it defaults to the current locale
def pluralize(count, singular, plural_arg = nil, plural: plural_arg, locale: I18n.locale)
  word = if (count == 1 || count.to_s =~ /^1(\.0+)?$/)
    singular
  else
    # if we didn't provide a plural form, it uses the string's pluralize method
    plural || singular.pluralize(locale)
  end

  "#{count || 0} #{word}"
end
```

## Conclusion

We have covered more ways to make our methods super flexible so that we can use the methods and customize their behavior to our needs.

There are more small tricks that we can use, but it would make this article too long and repetitive, I recommend reading [this official anouncement](https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/) about the small differences introduced for Ruby 2.7 and Ruby 3.
