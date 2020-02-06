---
layout: post
title:  "Present? vs Any? vs Exists?"
date: 2016-12-02 13:31:00
categories: ["benchmark", "performance", "rails"]
author: "mauro-oto"
published: false
---

When working on a Rails project, you may have seen `present?` calls on
ActiveRecord relationships. This might feel natural, mostly because `present?`
exists on all objects [via ActiveSupport](http://guides.rubyonrails.org/active_support_core_extensions.html#blank-questionmark-and-present-questionmark), so you expect the relationship to respond to it,
but it's actually not a very good idea. If all we want to do is check if the
scope returns any results from the database, there are better ways than using
`present?`.

<!--more-->

*In Rails 5.1 and up, the performance of `any?` and `exists?` has been fixed, so
they are now equally performant.*

`present?` is slow because:

```ruby
irb(main):003:0> Project.find(57).tasks.where.not(deleted_at: nil).present?
Project Load (0.5ms)  SELECT  "projects".* FROM "projects"  WHERE "projects"."enabled" = 't' AND "projects"."id" = $1 LIMIT 1  [["id", 57]]
Task Load (918.7ms)  SELECT "tasks".* FROM "tasks" INNER JOIN "boards" ON "tasks"."board_id" = "boards"."id" WHERE "tasks"."enabled" = 't' AND "boards"."project_id" = $1 AND "boards"."enabled" = 't' AND ("tasks"."deleted_at" IS NOT NULL)  [["project_id", 57]]
=> true
```

As you can see in the snippet above, we're loading one project, and then loading
all of its tasks to check for presence using `present?`. This ends up taking
quite a bit of time (~900ms), hurting the performance of the app both memory and
time-wise.

A slightly better approach would be using `any?`:

```ruby
irb(main):004:0> Project.find(57).tasks.where.not(deleted_at: nil).any?
Project Load (0.9ms)  SELECT  "projects".* FROM "projects"  WHERE "projects"."enabled" = 't' AND "projects"."id" = $1 LIMIT 1  [["id", 57]]
(119.0ms)  SELECT COUNT(*) FROM "tasks" INNER JOIN "boards" ON "tasks"."board_id" = "boards"."id" WHERE "tasks"."enabled" = 't' AND "boards"."project_id" = $1 AND "boards"."enabled" = 't' AND ("tasks"."deleted_at" IS NOT NULL)  [["project_id", 57]]
=> true
```

`any?` uses [SQL count](http://www.w3schools.com/sql/sql_func_count.asp) instead
of loading each task, resulting in a faster, more performant result (from ~900ms
down to ~100ms). However, what we actually want to know in this case is if there
is at least one record in our scope. We don't really need to count all of the
tasks, it should stop after finding the first one. So applying `LIMIT` would
solve that for us, and that's how `exists?` saves the day:

```ruby
irb(main):005:0> Project.find(57).tasks.where.not(deleted_at: nil).exists?
Project Load (0.5ms)  SELECT  "projects".* FROM "projects"  WHERE "projects"."enabled" = 't' AND "projects"."id" = $1 LIMIT 1  [["id", 57]]
Task Exists (0.9ms)  SELECT  1 AS one FROM "tasks" INNER JOIN "boards" ON "tasks"."board_id" = "boards"."id" WHERE "tasks"."enabled" = 't' AND "boards"."project_id" = $1 AND "boards"."enabled" = 't' AND ("tasks"."deleted_at" IS NOT NULL) LIMIT 1  [["project_id", 57]]
=> true
```

By limiting the count to 1, after finding the first record, it returns true.
Notice the time in the debug lines in parenthesis, we went from ~900ms using
`present?`, to ~100ms using `any?`, to ~1ms using `exists?`.

Finally, here's a benchmark (using [benchmark-ips](https://github.com/evanphx/benchmark-ips)) which shows the difference in execution time between the three methods:

```ruby
Benchmark.ips do |x|
  x.report("present?") do
    Project.find(1).tasks.where.not(deleted_at: nil).present?
  end
  x.report("any?") do
    Project.find(1).tasks.where.not(deleted_at: nil).any?
  end
  x.report("exists?") do
    Project.find(1).tasks.where.not(deleted_at: nil).exists?
  end
  x.compare!
end

 exists?:      158.4 i/s
    any?:       10.1 i/s - 15.65x  slower
present?:        2.3 i/s - 68.39x  slower
```

NOTE: The examples shown in this post are taken from a Rails 4.2 app, using
PostgreSQL. I am not sure if this behavior remains the same in newer versions
of Rails.

If you're currently using `present?` in your projects, it should be a
quick performance win to replace these calls to use either `any?` or `exists?`.
