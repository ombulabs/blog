---
layout: post
title: "Understanding Bundler - To `bundle exec` or not? that is the question"
date: 2020-07-29 12:00:00
categories: ["ruby", "learning"]
author: arieljuod
---

We, Ruby developers, are used to running scripts or commands with the prefix `bundle exec`, but sometimes it's not needed, but sometimes it is, and when it's not needed it still works just fine if we add it. So it may not be clear why we need to use it in some cases.

In this blogpost I'll try to answer these questions with a little insight on what Bundler (and Ruby and Rubygems) do.

<!--more-->

## What does Bundler do?

We use Bundler for a few different things:

- Resolve dependencies and versions for all the gems required in a project
- Store the calculated versions in a file so all the developers have the same gem versions
- Make sure our Ruby code has access to those specific versions of the gems
- We can use it to know which gems have new versions that will still fulfill all the other gems' version restrictions

I'm only going to talk about how Bundler makes sure our code uses specific versions of the gems.

## The Problem

When we are writing a Ruby script, if we want to use code from another script, we would use something like `require 'csv'`, and Ruby will try to find that in our system.

> `require` is a method defined in the [Kernel](https://ruby-doc.org/core-2.6.6/Kernel.html#method-i-require) module.
>
> There are more methods to require code (like `require_relative` or Rails' autoloading and lazy loading mechanisms), but I am only going to focus on this one for simplicity

How it does that depends on what we are trying to require.

### The $LOAD_PATH Global Variable

Ruby keeps track of an array with all the paths it knows where code should be. We have all seen this variable somewhere while coding, but it's one of those things we just don't want to touch because it can break something else.

If we print the content of this array, we can see a list of paths in our system:

```ruby
#irb
2.6.6 :001 > pp $LOAD_PATH
["/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/gems/2.6.0/gems/did_you_mean-1.3.0/lib",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/site_ruby/2.6.0",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/site_ruby/2.6.0/x86_64-darwin19",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/site_ruby",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/vendor_ruby/2.6.0",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/vendor_ruby/2.6.0/x86_64-darwin19",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/vendor_ruby",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/2.6.0",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/2.6.0/x86_64-darwin19"]
```

You can see, for example, that I'm running Ruby 2.6.6 and using RVM.

### Requiring a Module from the Standard Library

When we require something like the `csv` module, it is part of the standard library (i.e.: it comes with Ruby). In this case, we can go over all the paths listed in that array until we find a file named `csv.rb`. If we go to `/home/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/2.6.0` we indeed find it. Ruby does the same to find the script and then loads the module so we can use it.

When it can't find a file matching the name we required, it will raise an error. We have probably all seen more of that than we want to:

```ruby
LoadError (cannot load such file -- some_unknown_module)
```

### Requiring a Gem

If we look back at the `$LOAD_PATH` array we'll notice the only reference to a gem is the `did_you_mean` gem but there's no reference to a base `gems` directory. So, how do we tell Ruby where all the other gems are? If we don't, it would raise `LoadError`.

Here is where Rubygems comes into play. If you check the list of what Bundler does, you'll notice it does not download the gems, when we run `bundle install` it will use Rubygems to do that. Rubygems handles installation, uninstallation and activation of gems. When a gem is activated, Ruby will be able to find it.

Rubygems [overrides](https://github.com/rubygems/rubygems/blob/d1ba6eeb431c06af2bd381c3e6fff352f46be025/lib/rubygems/core_ext/kernel_require.rb#L34) the `require` method of the Kernel module to activate gems when needed. We are not going into too much details here, the kernel override is really complex and out of scope of this article.

For what we need to know, the new method will first check if there's a gem with that name in the directory Rubygems controls. If there's a gem, Rubygems adds a new path to the `$LOAD_PATH` array and then [call the original](https://github.com/rubygems/rubygems/blob/d1ba6eeb431c06af2bd381c3e6fff352f46be025/lib/rubygems/core_ext/kernel_require.rb#L168) `require` method. The original method will find the file we were looking for since it's now in the `$LOAD_PATH` thanks to Rubygems (this action of adding a path to the array is the `activation` of the gem).

This is our `$LOAD_PATH` after requiring a gem:

```ruby
#irb
2.6.6 :002 > require 'bundler'
 => true
2.6.6 :003 > pp $LOAD_PATH
["/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/gems/2.6.0/gems/did_you_mean-1.3.0/lib",
 "/Users/arielj/.rvm/gems/ruby-2.6.6/gems/bundler-2.1.4/lib",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/site_ruby/2.6.0",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/site_ruby/2.6.0/x86_64-darwin19",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/site_ruby",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/vendor_ruby/2.6.0",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/vendor_ruby/2.6.0/x86_64-darwin19",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/vendor_ruby",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/2.6.0",
 "/Users/arielj/.rvm/rubies/ruby-2.6.6/lib/ruby/2.6.0/x86_64-darwin19"]
```

We can see that the second element of the array is now the path of bundler. But why is it loading version `2.1.4` and not a different one?

### Requiring a Specific Version of a Gem

Rubygems will activate the newest version we have installed on our system. This can quickly became a problem:

- if I update a gem when working on a project, it will also change for other projects on my machine
- if another developer joins the project, that developer will have to download the gems with the same versions I used
- new gems version may not be compatible with other gems that my project depends on

This is, finally, where Bundler comes into play. All projects that uses Bundler will have a `Gemfile` file (\*) specifying the gems and version restrictions we need for each project, and also, after running Bundler, it will have a `Gemfile.lock` file with the specific gem versions (or git commit hashes) Bundler calculated to make all the gems compatible.

> (\*) `Gemfile` is the default name, but can be changed, you could have a project with a different file name but with a file serving the same purpose

When executing Bundler, it will take care of reading this `Gemfile.lock` file and will activate the specified versions of each gem! (i.e.: it will add the paths to the `$LOAD_PATH` array). Now, when we require a gem, Ruby will find the gem and it will be the specified version. If it's not found, it will fallback to the Rubygems `require` method so we can still require gems that are not listed in our `Gemfile.lock` file.

### How to Use Bundler

Bundler can be used in two different ways:

- We can prefix our commands with `bundle exec`
- We can run Bundler programmatically

#### Using `bundle exec my_command`

When we do this, Bundler will load before our script. It will read the `Gemfile.lock` file, add all the paths for each gem into the `$LOAD_PATH` array, and then it will execute `my_command`. That way, our script will have the gems activated.

#### Running Bundler Programmatically

Bundler is a gem like any other, so we can require it inside our script and execute its `require` method to make it load all the paths into the `$LOAD_PATH` array when we want to:

```ruby
# irb
2.6.6 :001 > require 'bundler'
 => true
2.6.6 :002 > Bundler.require
```

This is actually what Rails does. If we open the file `config/application.rb` we can see something like this:

```ruby
# config/application.rb

if defined?(Bundler)
  ...
  Bundler.require(*Rails.groups(assets: %w[development test]))
  ...
end
```

But it's not just Rails, the Hanami framework also uses this approach:

```ruby
# https://github.com/hanami/hanami/blob/master/bin/hanami

require 'bundler'
...

::Bundler.require(:plugins) if File.exist?(ENV["BUNDLE_GEMFILE"] || "Gemfile")
...
```

This second method gives us the freedom to use Bundler if present and not use it if not, and it also saves use from having to use `bundle exec` before every command.

### Sometimes `rails` Command is not Found

I just said that a Rails app calls `Bundler.require` so adding the `bundle exec` prefix is not needed, but probably we all had this issue where we want to run `rails s` or `rails c` and it won't find the `rails` command, and then we have to run it using `bundle exec rails ...` anyway.

This happens because the system can't find the `rails` command. Similar to Ruby's `$LOAD_PATH` array, our system has a `PATH` environment variable to look for the commands we want to run. `bundle` executable is installed in the same directory as the `ruby` executable, but `rails` executable may be in a different one that's not in the paths the `PATH` env variable lists.

In those cases we have three options:

- add the missing path to the `PATH` env variable
- prefix our commands with `bundle exec`
- use the executables we may have in the bin folder of our project

Running `bundle exec` and `Bundler.require` at the same time is not a problem, so it's safe to use `bundle exec` even when not needed as long as there's a `Gemfile` in that directory, it won't activate gems twice.

## Bonus: How RVM works?

Since we are already talking about the `PATH` env variable, let's see what RVM does to change which Ruby version we want to use.

This is my `PATH` when using Ruby 2.6.6 in bash:

```bash
# bash
% echo $PATH
/Users/arielj/.rvm/gems/ruby-2.6.6/bin:/Users/arielj/.rvm/gems/ruby-2.6.6@global/bin:/Users/arielj/.rvm/rubies/ruby-2.6.6/bin:/Users/arielj/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin
```

And after running `rvm use 2.6.2`:

```bash
# bash
% rvm use 2.6.2
Using /Users/arielj/.rvm/gems/ruby-2.6.2

% echo $PATH
/Users/arielj/.rvm/gems/ruby-2.6.2/bin:/Users/arielj/.rvm/gems/ruby-2.6.2@global/bin:/Users/arielj/.rvm/rubies/ruby-2.6.2/bin:/Users/arielj/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin
```

We can see it simply changes the `PATH` env variable to point to the Ruby version we want to use. Now, when we run the `ruby` command, our system will find the executable inside one of those folders.

### Conclusion

We learned how Bundler and Rubygems interact with each other and "trick" Ruby to help us have a consistent environment and all the problems this technique solves (there are similar solutions for other programming languages, like [pip](https://pypi.org/project/pip/) for Python, [Composer](https://getcomposer.org) for PHP, [Yarn](https://yarnpkg.com) for NodeJs, etc).

We now have a better understanding to know when we would need to add the `bundle exec` prefix when running commands and when not to save some time.

And as a bonus, we also learned how RVM uses a somewhat similar solution to help run any Ruby version in one system.
