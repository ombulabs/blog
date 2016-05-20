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
[1] pry(main)> imap = Net::IMAP.new("imap.googlemail.com", 993, true)
=> #<Net::IMAP:0x007fde6b1a8ff0 ...
```

The third parameter here is `usessl`, it's set to `false` by
[default](https://github.com/ruby/ruby/blob/trunk/lib/net/imap.rb#L1065).

_If_ you run into any SSL issues and want to ignore them, you can use:

```ruby
[2] pry(main)> imap = Net::IMAP.new("imap.googlemail.com", 993, true, nil, false)
=> #<Net::IMAP:0x007fa1c77064b0 ...
```

which skips SSL verification. Note that while this is probably not such a good
idea, even the most popular Gmail Ruby gem,
[Gmail](https://github.com/gmailgem/gmail/blob/353ddcc8cc0c5b57ad1d3a412f11365ccc12b7d6/lib/gmail/client/base.rb#L26),
does this.

After the connection is established, you can login using a couple of different
ways. First, the most common way, using the email and the password:

```ruby
[3] pry(main)> imap.login(email, password)
=> #<struct Net::IMAP::TaggedResponse
 name="OK",
 raw_data="RUBY0001 OK c3p0@ombulabs.com authenticated (Success)\r\n">
```

Second, you can include the [gmail_xoauth](https://github.com/nfo/gmail_xoauth)
gem, which adds the XOAUTH2 authenticator to `Net::IMAP`, allowing you to use an
OAuth 2.0 token to login:

```ruby
[3] pry(main)> imap.authenticate("LOGIN", email, your_oauth2_token)
=> #<struct Net::IMAP::TaggedResponse ...
```

## Listing available mailboxes

To list all of your mailboxes:

```ruby
[4] pry(main)> imap.list("", "*")
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
[5] pry(main)> imap.list("", "*Mail")
=> [#<struct Net::IMAP::MailboxList attr=[:All, :Hasnochildren], delim="/", name="[Gmail]/All Mail">,
 #<struct Net::IMAP::MailboxList attr=[:Hasnochildren, :Sent], delim="/", name="[Gmail]/Sent Mail">]
```

## Selecting a mailbox

Most IMAP interactions require having selected a mailbox before doing them.
There are two ways to do so:

Read-only:

```ruby
[6] pry(main)> imap.examine("[Gmail]/All Mail")
=> #<struct Net::IMAP::TaggedResponse
 name="OK",
 raw_data="RUBY0014 OK [READ-ONLY] [Gmail]/All Mail selected. (Success)\r\n">
```

Read and write:

```ruby
[7] pry(main)> imap.select("[Gmail]/All Mail")
=> #<struct Net::IMAP::TaggedResponse
 name="OK",
 raw_data="RUBY0015 OK [READ-WRITE] [Gmail]/All Mail selected. (Success)\r\n">
```

## Searching email messages

After selecting an email box, you can search email messages and return either
the sequence number (`seqno`) for the email, or the unique id (`uid`).

The sequence number indicates the *current position* of the email message in the
mailbox. So this number will be different after email messages before this email
get moved to a different mailbox, or if they get deleted:

```ruby
# Search emails which have a subject that includes the word Jedi and return the sequence number.
[8] pry(main)> imap.search(["SUBJECT", "Jedi"])
=> [12]

# From within Gmail, we delete one of our very first emails in the All Mail box and then make the same search we did before.

[9] pry(main)> imap.search(["SUBJECT", "Jedi"])
=> [11]
```

The unique id is a unique identifier for the email in a mailbox. So even if the
email's position moves, the `uid` remains the same:

```ruby
# Search emails which have a subject that includes the word Jedi and return the unique id.
[10] pry(main)> imap.uid_search(["SUBJECT", "Jedi"])
=> [23]

# From within Gmail, we delete one of our very first emails in the All Mail box and then make the same search we did before.

[11] pry(main)> imap.uid_search(["SUBJECT", "Jedi"])
=> [23]
```

## Fetching email messages

After we selected a mailbox and we know a message's `seqno` or `uid`, we can
fetch the contents of the email. If you know the `seqno`:

```ruby
[12] pry(main)> imap.fetch(11, "ENVELOPE")
=> [#<struct Net::IMAP::FetchData
  seqno=11,
  attr=
   {"ENVELOPE"=>
     #<struct Net::IMAP::Envelope
      date="Thu, 12 Feb 2015 14:55:38 -0300",
      subject="Wanna be a Jedi?",
      from=[#<struct Net::IMAP::Address name="Mauro Otonelli", route=nil, mailbox="mauro", host="ombulabs.com">],
      sender=[#<struct Net::IMAP::Address name="Mauro Otonelli", route=nil, mailbox="mauro", host="ombulabs.com">],
      reply_to=[#<struct Net::IMAP::Address name="Mauro Otonelli", route=nil, mailbox="mauro", host="ombulabs.com">],
      to=[#<struct Net::IMAP::Address name="C3P0 Tripio", route=nil, mailbox="c3p0", host="ombulabs.com">],
      cc=nil,
      bcc=nil,
      in_reply_to=nil,
      message_id="<CBM2vBoqhzb_t4P8BFdGLZFnOHsUJDo1P-TkGbU_EGqxGVfZCyQ@mail.gmail.com>">}>]
```

If you know the `uid`:

```ruby
[13] pry(main)> imap.uid_fetch(23, "ENVELOPE")
=> [#<struct Net::IMAP::FetchData
  seqno=11,
  attr=
   {"UID"=>23,
    "ENVELOPE"=>
     #<struct Net::IMAP::Envelope
      date="Thu, 12 Feb 2015 14:55:38 -0300",
      subject="Wanna be a Jedi?",
      from=[#<struct Net::IMAP::Address name="Mauro Otonelli", route=nil, mailbox="mauro", host="ombulabs.com">],
      sender=[#<struct Net::IMAP::Address name="Mauro Otonelli", route=nil, mailbox="mauro", host="ombulabs.com">],
      reply_to=[#<struct Net::IMAP::Address name="Mauro Otonelli", route=nil, mailbox="mauro", host="ombulabs.com">],
      to=[#<struct Net::IMAP::Address name="C3P0 Tripio", route=nil, mailbox="c3p0", host="ombulabs.com">],
      cc=nil,
      bcc=nil,
      in_reply_to=nil,
      message_id="<CBM2vBoqhzb_t4P8BFdGLZFnOHsUJDo1P-TkGbU_EGqxGVfZCyQ@mail.gmail.com>">}>]
```

If you wanted to fetch a range of `uid`s, you can use a range:

```ruby
[14] pry(main)> imap.uid_fetch(1..23, "ENVELOPE")
=> [#<struct Net::IMAP::FetchData
  seqno=1,
  attr=
   {"UID"=>1,
    "ENVELOPE"=>
     #<struct Net::IMAP::Envelope
      date="Wed, 19 Nov 2014 12:01:13 -0800",
      subject="How to use Gmail with Google Apps",
      from=[#<struct Net::IMAP::Address name="Gmail Team", route=nil, mailbox="mail-noreply", host="google.com">],
      sender=[#<struct Net::IMAP::Address name="Gmail Team", route=nil, mailbox="mail-noreply", host="google.com">],
      reply_to=[#<struct Net::IMAP::Address name="Gmail Team", route=nil, mailbox="mail-noreply", host="google.com">],
      to=[#<struct Net::IMAP::Address name="C3P0 Tripio", route=nil, mailbox="c3p0", host="ombulabs.com">],
      cc=nil,
      bcc=nil,
      in_reply_to=nil,
      message_id="<CALqaawdvBhnXcFZ3ztSro8OcdLoRGt-Q0rSWTe7YXjR37dxrzQ@mail.gmail.com>">}>,
 #<struct Net::IMAP::FetchData
  seqno=2,
  attr=
   {"UID"=>2,
    "ENVELOPE"=>
     #<struct Net::IMAP::Envelope
      date="Wed, 19 Nov 2014 12:01:14 -0800",
      subject="The best of Gmail, wherever you are",
      from=[#<struct Net::IMAP::Address name="Gmail Team", route=nil, mailbox="mail-noreply", host="google.com">],
      sender=[#<struct Net::IMAP::Address name="Gmail Team", route=nil, mailbox="mail-noreply", host="google.com">],
      reply_to=[#<struct Net::IMAP::Address name="Gmail Team", route=nil, mailbox="mail-noreply", host="google.com">],
      to=[#<struct Net::IMAP::Address name="C3P0 Tripio", route=nil, mailbox="c3p0", host="ombulabs.com">],
      cc=nil,
      bcc=nil,
      in_reply_to=nil,
      message_id="<CALqaaweWj3TZUS_0=Rg45G+XgHwORk2JG_BpB2DHB3UPMR8WDg@mail.gmail.com>">}>,
#<struct Net::IMAP::FetchData
 seqno=3,
 attr=
  {"UID"=>3,
   "ENVELOPE"=>
    #<struct Net::IMAP::Envelope
    ...
```

## Logging out and disconnecting from the server

There is a usually a limit to the maximum amount of connections you can have
open to an IMAP server. Gmail for example, limits this to 15.
To correctly close an IMAP connection, you first need to log out, and then
disconnect from the server. You can use the `disconnected?` method to check
if you've actually closed the connection:

```ruby
[15] pry(main)> imap.logout
=> #<struct Net::IMAP::TaggedResponse
 tag="RUBY0002",
 name="OK",
 data=#<struct Net::IMAP::ResponseText code=nil, text="73 good day (Success)">,
 raw_data="RUBY0002 OK 73 good day (Success)\r\n">
imap.disconnected?
=> false
imap.disconnect
=> nil
imap.disconnected?
=> true
```

I hope this guide was useful, I tried to cover the most important operations,
but there's obviously more, such as deleting emails, marking emails as read,
adding emails to a mailbox, etc. If you've struggled with IMAP like I have, or
if you found this useful, let me know in the comments section!
