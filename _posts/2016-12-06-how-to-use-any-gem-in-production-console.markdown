---
layout: post
title:  "How to use any gem in the Rails production console"
date: 2016-12-06 11:06:00
categories: ["rails", "ruby"]
author: "mauro-oto"
---

How many times did you come across a great gem you wanted to try out in
a production console, like [benchmark-ips](https://github.com/evanphx/benchmark-ips) or
[awesome-print](https://github.com/awesome-print/awesome_print)? Be it for
performance reasons or for readability, sometimes it's nice to be able to try
out something quickly without going through a pull request and deployment
process. This is possible by modifying the [$LOAD_PATH](http://ruby-doc.org/core-2.3.0/doc/globals_rdoc.html)
Ruby global variable and requiring the gem manually.

`$LOAD_PATH` is an alias for `$:`, which essentially contains an array of paths
that your app will search through when using the Kernel method `require`.

```
$LOAD_PATH << "/usr/local/rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/benchmark-ips-2.7.2/lib"
require '/usr/local/rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/benchmark-ips-2.7.2/lib/benchmark/ips.rb'
```

<!--more-->
