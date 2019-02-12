---
layout: post
title: "Three Useful Data Migration Patterns for Rails"
date: 2019-02-05 10:00:00
categories: ["rails", "data-migrations"]
author: "etagwerker"
---

At [Ombu Labs](https://www.ombulabs.com), we are big fans of [Ruby on Rails](https://rubyonrails.org) and [design patterns](https://www.ombulabs.com/blog/tags/design-patterns), especially [convention over configuration](https://rubyonrails.org/doctrine/#convention-over-configuration)! The beauty of Rails is that
you can inherit a legacy project and easily find the different layers of code
in different directories.

When it comes to database migrations the policy of Rails is very clear. It's all
about altering the database structure with gradual migration files:
*"Migrations are a convenient way to alter your database schema over time in a
consistent and easy way."* ([source](https://edgeguides.rubyonrails.org/active_record_migrations.html#migration-overview))

But, what about data migrations? What's the best way to write, maintain, and run
migrations that alter the data in your production database?

In this article I will talk about three different patterns for writing and
maintaining your data migrations:

1. Data migrations in `db/migrate`
2. Data migrations with a set of Rake tasks
3. Data migrations with `data_migrate`

<!--more-->

## Data migrations in `db/migrate`

When you are starting with Ruby on Rails, it seems like a good idea to add data
migrations to your database migrations. You can quickly take advantage of
core Rails functionality and start modifying records across environments.

Let's say that you need to change the default state of a blog post, you can
create a migration file like this:

```
rails generate migration ChangeDefaultState
  invoke  active_record
  create  db/migrate/20190211222539_change_default_state.rb
```

In that file, you can write a statement like this one:

```
class ChangeDefaultState < ActiveRecord::Migration[5.1]
  def up
    Post.where(state: "Draft").update_all(state: "TODO")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```

Great! You're done. You run your migration and then you forget about it. Months
later your client comes along and wants you to change the table name from `posts`
to `articles`. Sounds like a pretty simple change, right? Sure!

You change the table name, rename the model, submit your pull request, fix the
build, the build passes, the code review passes, and it gets deployed to
production. What you may have missed is that now you no longer have a `Post` model
in your app.

The next time you need to set up a development environment, you create your
database, you run your migrations, and you get a failure in your console: Rails
does not know what `Post` is:

```
$ rails db:migrate
== 20190211222539 AddDefaultState: migrating ==================================
rails aborted!
StandardError: An error has occurred, this and all later migrations canceled:
uninitialized constant AddDefaultState::Post
/Users/etagwerker/Projects/ombulabs/points/db/migrate/20190211222539_change_default_state.rb:3:in `change'
```

The solution is quite simple: You need to rename the model in your migration.
There are patches that you could apply, but I won't go down the rabbit hole.
**This pattern is not the best approach.**

To sum things up, here are the pros and cons of this pattern:

### Pros

- It's quick because you can ship a data migration in a few minutes
- You use Rails core logic that makes sure you don't run a migration more than once

### Cons

- Migrations fall out of date very quickly and you don't have a quick way to find out
- You're not following Rails conventions: Files in `db/migrate` should migrate database structure, not database records

At Ombu Labs we consider this practice an [anti-pattern](http://wiki.c2.com/?AntiPattern).
We strongly advise you **not to include data migration code in your `db/migrate`
files**.

> Disclaimer: One way to make sure that your migrations don't fall out of date is
to run them constantly. You could run `rake db:migrate` every time you run your
build, but that would slow down your build. Usually you want to use the much
faster `rake db:schema:load` before you start running your test suite.

## Data migrations with a set of rake tasks

If you have gotten bitten by the first approach before, you know there is a
better way. You can write a bit more code and solve this problem using
plain old rake tasks that follow a new set of conventions.

```
namespace :data do
  task :migrations do
    Rake.application.in_namespace(:data) do |namespace|
      namespace.tasks.each do |t|
        next if t.name == "data:migrations"
        puts "Invoking #{t.name}:"
        t.invoke
      end
    end
  end

  task change_default_state: :environment do
    puts "Changing default state for posts"
    Post.where(state: "Draft").update_all(state: "TODO")
    puts "Changed default state for posts"
  end

  ...
```

The first rake task (`rake data:migrations`) will run all tasks in the `data`
namespace excluding itself. This can be a little scary (and dangerous!) so you
should make sure that all rake tasks in that namespace are idempotent. You want
to be able to run `rake data:migrations` as much as you want without risking
data loss.

The problem with this approach is that it doesn't actually fix the problem we
mentioned in the first pattern: As your application evolves, your *data rake
tasks* will fall out of date. How can we fix that?

The best way is to fix it with an additional class. We can call it
`ChangeDefaultStateForPosts`. It will be PORO that will run the data migration.
This will help us add test coverage for it.

```
class ChangeDefaultStateForPosts
  def self.call
    Post.where(state: "Draft").update_all(state: "TODO")
  end
end
```

Now that we have a simple class, we can write a simple spec:

```
RSpec.describe ChangeDefaultStateForPosts do
  describe "ChangeDefaultStateForPosts.call" do
    let!(:post) do
      Post.create(state: state)
    end

    context "when post is in 'Draft' state" do
      let(:state) { "Draft" }

      it "changes the state of the Draft" do
        expect do
          ChangeDefaultStateForPosts.call
        end.to change(post, :state)
      end
    end

    context "when post is in another state" do
      let(:state) { "Published" }

      it "doesn't change the state" do
        expect do
          ChangeDefaultStateForPosts.call
        end.not_to change(post, :state)
      end
    end
  end
end
```

Now we know that the data migration is covered by a spec. When someone tries
to rename the `posts` table to `articles`, they will get a test failure. This
will force them to update the data migration file.

### Pros

- You have test coverage for your data migrations
- You will find out there is a failure right away

### Cons

- You have to write more code
- You have to document this new convention

## Data migrations with `data_migrate`

I know what you are thinking: "There has to be a gem for this!"

You are right! You could use [`data_migrate`](https://rubygems.org/gems/data_migrate)
for all your data migrations. Just like Rails with the table `schema_migrations`,
`data_migrate` uses a table called `data_migrations` to keep track of new and
old migrations.

For the problem we are trying to solve, you could create a new data migration
like this:

```
rails generate data_migration change_default_state_for_posts
```

That will add a new data migration to the `db/data` directory. You will need to
define the `up` and `down` methods:

```
class ChangeDefaultStateForPosts < ActiveRecord::Migration[5.1]
  def up
    Post.where(state: "Draft").update_all(state: "TODO")
  end

  def down
    Post.where(state: "TODO").update_all(state: "Draft")
  end
end
```

To make sure that your data migrations don't fall out of date, you can set up
your build to run `rake db:schema:load:with_data` before your test suite.

### Pros

- You have a quick way to run the data migrations without writing extra code
- You will find out there is a failure right away

### Cons

- You have to add a new dependency to your project
- You have to document this new convention

## What's the best strategy?

I believe that the best way to solve this problem is to use `data_migrate`. You
will write less code, keep all data migrations in a `db/data` directory, and
have a good way to keep track of data changes.
