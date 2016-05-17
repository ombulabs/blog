---
layout: post
title: "A comprehensive guide to interacting with IMAP using Ruby"
date: 2016-05-16 10:50:00
categories: ["ruby", "imap"]
author: "mauro-oto"
---

A few times in the past I've had to interact with IMAP via Ruby, and wrapping
your head around its API is not so easy. Not only is the IMAP API a bit obscure
and cryptic, but Ruby's IMAP [documentation](http://ruby-doc.org/stdlib-2.2.3/libdoc/net/imap/rdoc/Net/IMAP.html)
is not so great either.

Searching the internet for examples doesn't yield too many results, so I'll try
to write down some of the things I've learned. The examples I'll show use
Gmail as the target IMAP server.

<!--more-->

## Connecting and logging in

To establish an IMAP connection:

```ruby
imap = Net::IMAP.new("imap.googlemail.com", 993, true)
=> #<Net::IMAP:0x007fde6b1a8ff0 ...
```

The third parameter here is `usessl`, it's set to `false` by
[default](https://github.com/ruby/ruby/blob/trunk/lib/net/imap.rb#L1065).

_If_ you run into any SSL issues and want to ignore them, you can use:

```ruby
imap = Net::IMAP.new("imap.googlemail.com", 993, true, nil, false)
=> #<Net::IMAP:0x007fa1c77064b0 ...
```

which skips SSL verification. Note that while this is probably not such a good
idea, even the most popular Gmail Ruby gem,
[Gmail](https://github.com/gmailgem/gmail/blob/353ddcc8cc0c5b57ad1d3a412f11365ccc12b7d6/lib/gmail/client/base.rb#L26),
does this.

After the connection is established, you can login using a couple of different
ways. First, the most common way, using the email and the password:

```ruby
imap.login(email, password)
=> #<struct Net::IMAP::TaggedResponse
 name="OK",
 raw_data="RUBY0001 OK c3p0@ombulabs.com authenticated (Success)\r\n">
```

Second, you can include the [gmail_xoauth](https://github.com/nfo/gmail_xoauth)
gem, which adds the XOAUTH2 authenticator to `Net::IMAP`, allowing you to use an
OAuth 2.0 token to login:

```ruby
imap.authenticate("LOGIN", email, your_oauth2_token)
=> #<struct Net::IMAP::TaggedResponse ...
```

## Listing available mailboxes

To list all of your mailboxes:

```ruby
imap.list("", "*")
=> [#<struct Net::IMAP::MailboxList attr=[:All, :Hasnochildren], delim="/", name="[Gmail]/All Mail">,
 #<struct Net::IMAP::MailboxList attr=[:Drafts, :Hasnochildren], delim="/", name="[Gmail]/Drafts">,
 #<struct Net::IMAP::MailboxList attr=[:Hasnochildren, :Important], delim="/", name="[Gmail]/Important">,
 #<struct Net::IMAP::MailboxList attr=[:Hasnochildren, :Sent], delim="/", name="[Gmail]/Sent Mail">,
 #<struct Net::IMAP::MailboxList attr=[:Hasnochildren, :Junk], delim="/", name="[Gmail]/Spam">,
 #<struct Net::IMAP::MailboxList attr=[:Flagged, :Hasnochildren], delim="/", name="[Gmail]/Starred">,
 #<struct Net::IMAP::MailboxList attr=[:Hasnochildren, :Trash], delim="/", name="[Gmail]/Trash">]
```

To search your mailboxes by name, using `*` as a wildcard character:

```ruby
imap.list("", "*Mail")
=> [#<struct Net::IMAP::MailboxList attr=[:All, :Hasnochildren], delim="/", name="[Gmail]/All Mail">,
 #<struct Net::IMAP::MailboxList attr=[:Hasnochildren, :Sent], delim="/", name="[Gmail]/Sent Mail">]
```

## Selecting a mailbox

Most IMAP interactions require having selected a mailbox before doing them.
There are two ways to do so:

Read-only:

```ruby
imap.examine("[Gmail]/All Mail")
=> #<struct Net::IMAP::TaggedResponse
 name="OK",
 raw_data="RUBY0014 OK [READ-ONLY] [Gmail]/All Mail selected. (Success)\r\n">
```

Read and write:

```ruby
imap.select("[Gmail]/All Mail")
=> #<struct Net::IMAP::TaggedResponse
 name="OK",
 raw_data="RUBY0015 OK [READ-WRITE] [Gmail]/All Mail selected. (Success)\r\n">
```

## Searching email messages

```ruby
```


## Fetching email messages

```ruby
```
