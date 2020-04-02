---
layout: post
title:  "Step up the security of your Rails app | Part 1"
date: 2018-09-25 12:10:00
reviewed: 2020-03-05 10:00:00
categories: ["rails", "security"]
author: "luciano"
---

The internet is a wonderful place, but there will always be people that don't have good intentions when they visit our websites. That's why you need to be aware of the vulnerabilities that your application can have and how to avoid them. In this article I'll cover two common security problems in [Rails](https://rubyonrails.org) applications (I'll probably make a second part since this is a very extensive topic).

<!--more-->

It's also worth to mention that Rails itself has improved a lot [over the years](https://www.youtube.com/watch?v=Btrmc1wO3pc) to make everything more secure and easy for the people who use it. That's one of the reasons why it's so important to [upgrade your Rails project](https://www.ombulabs.com/blog/tags/upgrades).

Before we start you should know that Rails has an [official security guide](https://guides.rubyonrails.org/security.html) with a large variety of common vulnerabilities. I recommend to take a look at it if you want to dive deeper into this topic. Also at the end of this article I'll leave a few links to some useful tools that will help you level up security in your Rails application.

Okay, let's jump into it:

## Command Injection
#### What is it?
It allows the attacker to run any command on your server.
[Ruby](https://www.ruby-lang.org/en/) has a [method](https://apidock.com/ruby/Kernel/eval) called `eval` which can take a string and execute what's inside of it. This can likely be the reason of this security issue if you use it the wrong way.

#### Example

```ruby
# User input
params[:shop][:items_ids] # Maybe you expect this to be an array inside a string.
                          # But it can contain something very dangerous like:
                          # "Kernel.exec('Whatever OS command you want')"

# Vulnerable code
evil_string = params[:shop][:items_ids]
eval(evil_string)

# BOOM!
```

#### How to avoid it?
`eval` is a very powerful method that should only be used in a few specific cases. Most of the time it is possible to accomplish the same goal with a safer solution.
If you see a call to `eval` you must be very sure that you are properly sanitizing it. Using [regular expressions](https://ruby-doc.org/core-2.5.1/Regexp.html) is a good way to accomplish that.

```ruby
# Secure code
evil_string = params[:shop][:items_ids]
secure_string = /\[\d*,?\d*,?\d*\]/.match(evil_string).to_s

eval(secure_string)
```

---

## SQL Injection
#### What is it?
It allows the attacker to manipulate a specific [SQL](https://en.wikipedia.org/wiki/SQL) query that you have in your code and get unauthorized access to parts of your database. That way the attacker could do things like:
- Read information that should have been private
- Update records in your database that should have been out of reach
- Drop your database

Rails uses [Active Record](https://guides.rubyonrails.org/active_record_basics.html) as its default [ORM](https://en.wikipedia.org/wiki/Object-relational_mapping), and it's very efficient in terms of security. But it's still possible to write a vulnerable query.

#### Example

```ruby
# User input
params[:search] # You probably expect just a string with part of the user's name
                # But it can contain something like:
                # "'); DROP TABLE users; SELECT * FROM products WHERE (name LIKE '%"

# Vulnerable code
evil_string = params[:search]
User.where("first_name LIKE '%#{evil_string}%'")

# Bye users table
```
<a href="https://xkcd.com/327/" target="_blank">
  <img src="/blog/assets/images/exploits_of_a_mom.png" alt="Rails SQL Injection">
</a>

Take a look at [https://rails-sqli.org](https://rails-sqli.org) if you want to see a larger variety of examples for this exploit.

#### How to avoid it?
Avoid building your own conditions as pure strings. Putting the variable directly into the conditions string will pass the variable to the database without any kind of filter, which means a huge risk for your database.
Instead you should pass the variable as an extra param so it can get sanitized.

```ruby
# Secure query
User.where("first_name LIKE ?", "%#{params[:search]}%")
```

If you need to write a raw SQL query you should know that Active Record has the `quote` [method](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Quoting.html#method-i-quote) that will help you to sanitize it. There are also some useful [methods](https://api.rubyonrails.org/classes/ActiveRecord/Sanitization/ClassMethods.html) to sanitize each type of query.

---

## Useful resources
If you're interested in improving the security of your Rails app, here are some links that you might find useful:

- [Rails official security guide](https://guides.rubyonrails.org/security.html)
- [Rails security checklist](https://github.com/eliotsykes/rails-security-checklist)
- [OWASP Ruby on Rails Cheatsheet](https://www.owasp.org/index.php/Ruby_on_Rails_Cheatsheet)
- [Brakeman gem](https://github.com/presidentbeef/brakeman)
- [Secure Headers gem](https://github.com/twitter/secure_headers)

You can also try [RailsGoat](https://github.com/OWASP/railsgoat) to put in practice what you learnt.

## Conclusion
As a developer you should be careful of the code you write so you can avoid these kind of vulnerabilities. One of the best things you can do is to keep learning in order to be fully aware of the bad things that could happen. And remember, never trust user input!
