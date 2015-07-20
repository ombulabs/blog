---
layout: post
title: "Why using default_scope is a bad idea"
date: 2015-07-20 09:55:00
categories: ["ruby", "rails", "best practices"]
author: "mauro-oto"
---

`default_scope` is a method provided by ActiveRecord, which allows you to set
a default scope (as its name implies) for all operations done on a given model.
It can be useful for allowing soft-deletion in your models, by having a
`deleted_on` column on your model and default scoping the model to
`deleted_on: nil`.

```ruby
class Animal
  default_scope where(deleted_on: nil)
end
```

This will hide deleted records and only return non-deleted
ones in your queries after setting `deleted_on` instead of
calling `destroy`.

```ruby
> Animal.limit(5)
  Animal Load (4.2ms)  SELECT `animals`.* FROM `animals` WHERE `animals`.`deleted_on` IS NULL LIMIT 10
```

Quite useful! However, `default_scope` has a dangerous behavior:
**it affects your model's initialization.**

Say you were using STI on your `Animal` model, and you had a `default_scope`
for always filtering your model by "Cat":

```ruby
class Animal
  default_scope where(type: "Cat")
end
```

When you initialize a new Animal, it will always use the value defined in
your default scope:

```ruby
> Animal.new
=> #<Animal id: nil, created_at: nil, updated_at: nil, type: "Cat">
```

This can lead to some headaches when you're not aware of this side-effect, and
depending on the default scoped attribute/value it can cause some pretty bad
bugs.

Also, I'd like to mention the fact that it's very difficult to write queries
once you have used `default_scope` on a model. For example:
`Animal.where('deleted_on is not null')` won't work, you'd need to use
`Animal.unscoped`, which makes everything awkward. You also need to use
`unscoped` carefully, because it will remove all scopes of the relation, not just
the default scope.

I recommend always avoiding default scope if possible, or use with care, and
prefer explicit scopes instead.
