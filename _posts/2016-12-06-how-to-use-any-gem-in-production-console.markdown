---
layout: post
title:  "How to use any gem in the Rails production console"
date: 2016-12-06 11:06:00
categories: ["rails", "ruby"]
author: "mauro-oto"
---

How many times did you come across a great gem you wanted to try out in
a production console, like [benchmark-ips](https://github.com/evanphx/benchmark-ips)
or [awesome-print](https://github.com/awesome-print/awesome_print)?

Be it for performance or for readability, sometimes it's nice to be able to try
out something new quickly without going through a pull request + deployment
process. This is possible by modifying the [$LOAD_PATH](http://ruby-doc.org/core-2.3.0/doc/globals_rdoc.html)
Ruby global variable and requiring the gem manually.

<!--more-->

The Ruby global variable `$LOAD_PATH` is an alias for `$:`, which essentially
contains an array of paths that your app will search through when using the
Kernel method `require`.

Obviously the real solution here would be to just put the gem in your Gemfile,
and bundle. However, if you wish to use `benchmark-ips` to test the performance
of methods in a Rails console with production data and you don't have the gem
already bundled, then follow these steps:

- SSH into your target server
- Run `gem install benchmark-ips`
- Run `gem env gemdir` to figure out the path where gems are installed. For example:
```
/usr/local/rbenv/versions/2.1.2/lib/ruby/gems/2.1.0
```
- Open the Rails console
- Add the gem's path to the LOAD_PATH global variable, like so:
```
$LOAD_PATH << "/usr/local/rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/benchmark-ips-2.7.2/lib"
```
- Finally, require the gem's entry point file. You may need to look into the
gem's structure to figure out what file you need to require. For example, for
`benchmark-ips`:
```
require "/usr/local/rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/benchmark-ips-2.7.2/lib/benchmark/ips.rb"
```

This should let you use almost any gem you need in a Rails production console.
