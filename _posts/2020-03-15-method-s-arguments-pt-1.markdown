---
layout: post
title: Ruby Method's Arguments
date: 2020-03-15 09:30:00
categories: [ruby, learning]
author: arieljuod
---

Ruby is an object oriented language where everything is an object (even methods are objects of the class Method!), so everything we need to do is done by calling methods on objects. That also means that methods have to provide a lot of flexibility because they are used everywhere.

Ruby provides a lot of options to pass arguments to our methods, so we'll make this topic a series so it's not too long. We'll split the options into different categories and then break down everything with some examples and/or use cases.

<!--more-->

# Methods Vs. Functions

Both methods and functions serve the same purpose: encapsulate a piece of code to reuse it with ease. And some times we use them as sinonyms, but there's a conceptual difference:

- Functions return a result based only on the input, functions shouldn't depend on or modify the state of something that's not in the given inputs.
- Methods are always executed in the context of an object, so we can call a method with no arguments but we always have access to the method's state and we can modify it.

In Ruby, where everything is an object, we can never have real functions but we can have methods that won't use or modify the object's state if we want to have something similar.

# Arguments Vs. Parameters

Another thing that's worth differentiating is the concept of arguments and parameters. When we define a method, the parameters are part of the definition, the parameters are the variables that will contain the values that we use when calling that method. Arguments are the actual values that we use when we call a method. So, in this code:

```ruby
def my_method(foo)
  # foo is a parameter when defining the method
end

my_method("bar")
# "bar" is the argument we use when calling the method
```

Most of the times I'll use the word "arguments" for simplicity, since a method defines the parameters and accepts arguments.

# No arguments

We can have methods that have no input, like this:

```ruby
def pi # parenthesis are optional and the keyword "return" is optional too
  3.14
end
```

But given that this is a method, it has access to the object's state to do different things

```ruby
class Circle
  def initialize(radius)
    @radius = radius
  end

  def pi
    3.14
  end

  def area
    pi * @radius ** 2
  end
end

my_circle = Circle.new(3)
puts my_circle.area
# => 28.26

other_circle = Circle.new(4)
puts other_circle.area
# => 50.24
```

# Positional arguments

This type of argument gets that name because the order you use matters. You can have 0 or more positional arguments, and you can have required and optional arguments.

# Required positional arguments

These positional arguments are required when calling a method, it's not that it's required to use them when defining the method (you can have no arguments, only optionals, etc). If the method defines required parameters you have to provide an argument for each position.

```ruby
def foo(arg1)
  puts "arg1 is: #{arg1.inspect}"
end

foo(1)
# => arg1 is: 1

foo
# ArgumentError (wrong number of arguments (given 0, expected 1))
```

We can have as many as we want:

```ruby
def foo(arg1, arg2, arg3, arg4)
# and more and more...
```

> Note that methods with too many arguments are a sign of bad design since the method is probably doing too many things!

# Optional positional arguments

Sometimes we may want to allow the user to provide more input but not require them to do so. For that, we can use optional arguments for which we define a default value in case the user doesn't specify one. This is particularly useful when we want to have some default behavior for our method but give the user the option to modify that. If we just hardcoded the default value inside the method we wouldn't have this flexibility.

```ruby
def foo(arg1 = 'default value')
  puts "arg1 is: #{arg1.inspect}"
end

foo(1)
# => arg1 is: 1

foo
# => arg1 is: default value
```

We can have as many as we want, just like the required parameters.

# Combining required and optional positional arguments

Now we can combine both required and positional arguments in one method definition:

```ruby
def foo(arg1, arg2 = 'default value')
  puts "arg1 es: #{arg1.inspect}"
  puts "arg2 es: #{arg2.inspect}"
end

foo(1)
# => arg1 is: 1
#    arg2 is: default value

foo(1,2)
# => arg1 is: 1
#    arg2 is: 2
```

Usually, when we mix both types of arguments, we put the required arguments first and then the optional ones. But Ruby allows us to do weird things like:

```ruby
def foo(arg1, arg2 = 'default value', arg3)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
  puts "arg3 is: #{arg3.inspect}"
end
```

But this can create confusing situations:

```ruby
foo(1, 2, 3)
# => arg1 is: 1
#    arg2 is: 2
#    arg3 is: 3

foo(1,2)
# => arg1 is: 1
#    arg2 is: default value
#    arg3 is: 2
```

Notice that, on the second call, the second argument ends up at **arg3**. My first thought was that ruby first assigned the required arguments and then the optionals, but that's not the case. Check out this even more confusing example:

```ruby
def foo(arg1, arg2 = 'default value X', arg3 = 'default value Y', arg4)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
  puts "arg3 is: #{arg3.inspect}"
  puts "arg4 is: #{arg4.inspect}"
end

foo(1, 2, 3, 4)
arg1 is: 1
arg2 is: 2
arg3 is: 3
arg4 is: 4

foo(1, 2, 3)
arg1 is: 1
arg2 is: 2
arg3 is: "default value Y"
arg4 is: 3

foo(1, 2)
arg1 is: 1
arg2 is: "default value X"
arg3 is: "default value Y"
arg4 is: 2
```

What Ruby seems to do is:
- assign leftmost arguments to the first parameters
- assign rightmost arguments to the last parameters
- if there are not enough arguments, raise an error
- if there are unused arguments, assign them to the optional arguments in order from left to right

> I would recommend avoiding this combination unless it's something with a really specific requirement since it's not too intuitive and it's hard to follow.

Having optional arguments not grouped will raise an error:

```ruby
def foo(arg1, arg2 = 'default value2', arg3, arg4 = 'default value4')
end

# SyntaxError ((irb):1: syntax error, unexpected '=', expecting ')')
```

# Optional arguments based on other arguments

Default value for optional arguments can use the value of other arguments:

```ruby
def foo(arg1, arg2 = arg1 * 2)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo(1)
# => arg1 is: 1
#    arg2 is: 2

foo(1,3)
# => arg1 is: 1
#    arg2 is: 3
```

This can even depend on the value of optional arguments:

```ruby
def foo(arg1 = 1, arg2 = arg1 * 2)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo
# => arg1 is: 1
#    arg2 is: 2

foo(2)
# => arg1 is: 2
#    arg2 is: 4
```

The only requirement is that the arguments used in the default value were previously assigned, this won't work:

```ruby
def foo(arg1 = arg2 * 2, arg2 = 1)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo
# NameError (undefined local variable or method `arg2' for main:Object)
```

Also, we don't need to have simple operations like that for the default value, we can assign a function that will be called when assigning the values:

```ruby
def two_times(x)
  x * 2
end

def foo(arg1 = 1, arg2 = two_times(arg1))
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
end

foo
# => arg1 is: 1
#    arg2 is: 2

foo(5)
# => arg1 is: 5
#    arg2 is: 10 # it's multiplying 5, not 1, it uses our value, not te default one

foo(5, 6)
# => arg1 is: 5
#    arg2 is: 6 # we are actually overriding that multiplication
```

# Variable arguments

This type of optional positional arguments don't have a default value. They exist only if assigned and you can access them using a special array of arguments. For this we use the splat operator (*) when defining the parameter.

```ruby
def foo(*args) # we use this special syntax with the * (splat operator) at the beginning of the paremeter
  puts "args is: #{args.inspect}"
end

foo(1)
# => args is: [1]

foo(1,2)
# => args is: [1, 2]
```

> The parameter name doesn't have to be **args**, the required syntax is the * operator

You can combine this with required and optional arguments too:

```ruby
def foo(arg1, arg2 = 'default value', *args)
  puts "arg1 is: #{arg1.inspect}"
  puts "arg2 is: #{arg2.inspect}"
  puts "args is: #{args.inspect}"
end

foo(1, 2, 3, 4)
# => arg1 is: 1
#    arg2 is: 2
#    args is: [3, 4]

foo(1, 2, 3)
# => arg1 is: 1
#    arg2 is: 2
#    args is: [3]

foo(1, 2)
# => arg1 is: 1
#    arg2 is: 2
#    args is: []

foo(1)
# => arg1 is: 1
#    arg2 is: default value
#    args is: []
```

Notice that **args** is always an array. You usually deconstruct the array or use it as is as an array or to call another method:

```ruby
def bar(arg1, *args)
  puts "arg1 in bar is: #{arg1.inspect}"
  puts "args in bar is: #{args.inspect}"
end

def foo(arg1, *args)
  puts "arg1 in foo is: #{arg1.inspect}"
  puts "args in foo is: #{args.inspect}"

  # desconstruct the array
  dec1, dec2, *rest = args
  puts "dec1 is: #{dec1.inspect}"
  puts "dec2 is: #{dec2.inspect}"
  puts "rest is: #{rest.inspect}"

  # we need the * (splat operator) again so ruby deconstructs the array in different arguments
  # if we don't do this, args would be an array assigned to arg1 in bar
  # we'll talk about this with more details on another post
  bar(*args)
end

foo(1, 2, 3, 4)
# => arg1 in foo is: 1
#    arg2 in foo is: [2, 3, 4]
#    dec1 is: 2
#    dec2 is: 3
#    rest is: [4]
#    arg1 in bar is: 2
#    args in bar is: [3, 4]
```

> This special parameter must always be used after the other positional arguments.

# Conclusion

All these options gives us some flexibility, but the order being that rigid also forces us to remember and respect the order and also remember what each position is, which really limits us.

In the next post of this series we'll talk about keyword arguments that allow us to set arguments in any order, and on the next one we'll talk about the special block argument to inject code, some extra features like array deconstruction parameters and partially applied arguments to generate other methods.