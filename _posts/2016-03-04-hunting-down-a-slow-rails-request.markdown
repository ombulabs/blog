---
layout: post
title: "Hunting Down a Slow Rails Request"
date: 2016-03-04 11:03:00
reviewed: 2020-03-05 10:00:00
categories: ["rails", "performance"]
author: "mauro-oto"
---

Recently, we started using [Skylight](https://www.skylight.io) in production
for one of our clients' Rails applications, in an attempt to try to improve the
performance of some of the more critical API endpoints.

Skylight reports on:

- Time taken per request
- Breakdown of time taken per SQL query
- Object allocations per request

I noticed an unusually large amount of allocated objects for one request:

![Skylight report](/blog/assets/images/high-object-allocation.png)

This request would take anywhere from 400ms to 3000ms to respond, which is
__WAY__ too long.

<!--more-->

To debug this, I first captured the `String` object allocation count locally to
see how it behaved:

```ruby
Started GET "/email_accounts.json?results_per_page=30" for 127.0.0.1 at 2016-03-02 13:04:22 +0000
Processing by EmailAccountsController#index as JSON
  Parameters: {"results_per_page"=>"30"}

[[String, 150299], [Arel::Nodes::SqlLiteral, 5], [Arel::Nodes::BindParam, 4], [ActiveSupport::StringInquirer, 1]]
### JSON rendering happens here ###
[[String, 707982], [ActiveSupport::JSON::Encoding::JSONGemEncoder::EscapedString, 2922], [Arel::Nodes::SqlLiteral, 6], [ActiveSupport::StringInquirer, 1]]

Completed 200 OK in 5860ms (Views: 11.8ms | ActiveRecord: 564.9ms)
```

To get the amount of allocated strings, I used the following snippet:

```ruby
strings = {}
ObjectSpace.each_object(String) { |str| strings[str.class] += 1 }
pp strings
```

As you can see, there are 700k+ allocated strings. It is very likely that this
increase in object allocation is the culprit for the slow performance.

I dug a bit into the `EmailAccount` model and its associations, and noticed that
this model had a one-to-many association. Supposedly, we were only returning one
record for this association by using:

```ruby
scope.includes(:latest_sync)
```

and

```ruby
has_one :latest_sync, -> { order "email_account_syncs.last_attempt_at desc" },
                      class_name: "EmailAccountSync"
```

As it turns out, the `has_one :latest_sync` relationship was not being
respected by the query performed in the `index` action, and thus:

```ruby
EmailAccountSync Load (21.9ms)  SELECT "email_account_syncs".* FROM "email_account_syncs"  WHERE "email_account_syncs"."email_account_id" IN (24, 23, 22, 21, 20, 19, 18, 17, 16, 15)  ORDER BY email_account_syncs.last_attempt_at desc
```

This meant that all `EmailAccountSync` instances were getting loaded for each
`EmailAccount` record. The `limit` that should have been in the SQL statement
was not there.

I googled for a bit and found [this issue](https://github.com/rails/rails/issues/10621#issuecomment-77389988),
which suggests using `eager_load` instead of `includes`, which fixes the issue.

The downside is that it introduces an N+1 query problem, but it's a dramatical
performance gain:

```ruby
Started GET "/email_accounts.json?results_per_page=30" for 186.158.142.200 at 2016-03-02 13:41:44 +0000
Processing by EmailAccountsController#index as JSON
  Parameters: {"results_per_page"=>"30"}

[[String, 150295], [ActiveSupport::JSON::Encoding::JSONGemEncoder::EscapedString, 2110], [Arel::Nodes::SqlLiteral, 20], [Arel::Nodes::BindParam, 10], [ActiveSupport::StringInquirer, 1]]
### JSON rendering happens ###
[[String, 157847], [ActiveSupport::JSON::Encoding::JSONGemEncoder::EscapedString, 4220], [Arel::Nodes::SqlLiteral, 30], [Arel::Nodes::BindParam, 12], [ActiveSupport::StringInquirer, 1]]

Completed 200 OK in 178ms (Views: 5.6ms | ActiveRecord: 2.3ms)
```

The object allocation is down by a huge amount, and the request now takes from
50ms to 200ms to respond. This is not yet completely efficient, but it is a much
more acceptable value.
