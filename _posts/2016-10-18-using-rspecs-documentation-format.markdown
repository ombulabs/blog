---
layout: post
title:  "Brief look at RSpec's formatting options"
date: 2016-11-08 12:53:00
reviewed: 2020-03-05 10:00:00
categories: ["rspec", "ruby"]
author: "mauro-oto"
---

A few weeks ago, I noticed weird output in the [RSpec](https://relishapp.com/rspec)
test suite (~4000 tests) for a [Rails](http://rubyonrails.org) application:

```
.............................................................................................unknown OID 353414: failed to recognize type of '<field>'. It will be treated as String  ...........................................................................................................................................
```

This Rails app uses a [PostgreSQL](https://www.postgresql.org) database. After
some Googling, it turns out that this is a warning from PostgreSQL. When the
database doesn't recognize the type to use for a column, it casts to string by
default.

<!--more-->

I first thought I could look through previous CI runs to find out when this
warning first started showing up. Then I decided to use RSpec's documentation
format instead. I ran the build locally, and the test that triggers the warning
for the first time was exposed:

```
➜  myproject git:(develop) ✗ bundle exec rspec spec --format documentation

...

Admin::ClientsController
  GET 'index'
unknown OID 353414: failed to recognize type of 'client_campaigns'. It will be treated as String.
    non-admin user
      does not authorize non-admin users
    admin user
      lists all clients

...

```

The RSpec documentation format shows us the test description and the example
names. Because of this, we can tell what test we can run to reproduce the
warning. It also allows us to figure out where in the codebase the warning is
triggered from.

A good alternative to the documentation format is the [Fuubar gem](https://github.com/thekompanee/fuubar).
Using `rspec --format Fuubar`, you get a nice looking progress bar, as well as
its coolest feature, insta-failing tests. With Fuubar, you don't have to wait
until the build ends or until you ctrl+c out of RSpec, you get the failure
result right away. If you don't care about the build finishing after the first
failure, you can use RSpec's [fail fast](https://relishapp.com/rspec/rspec-core/docs/command-line/fail-fast-option)
option instead.

Since `--format Fuubar` doesn't show test descriptions by default, you can
combine Fuubar with the documentation format, using
`rspec --format Fuubar --format documentation`. This way, you get both the
documentation format and insta-failing tests. If you prefer this formatting to
RSpec's default formatting, remember you can always add the flag to your
`.rspec` file.
