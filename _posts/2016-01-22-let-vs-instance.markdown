---
layout: post
title: "Let vs Instance Variables"
date: 2016-01-22 10:36:00
categories: ["rails", "rspec", "ruby"]
author: "schmierkov"
---

Maybe in the past you stumbled over the two different approaches to setup your test variables. One way is the more programmatical approach by using instance variables, usually initialized in a `before` block.

<!--more-->

```ruby
  before do
    @user = User.create username: 'foo'
  end
```

The other option is `let`.

```ruby
  let(:user) { User.create username: 'foo' }
```

If you have seen this and you are still not sure, when to use instance variables and when `let`, then you will in the following examples.

For this example I have chosen a simple setup in which I want to create 2 users and check their attributes.

To properly reset the database with [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner) after each test, you can use this snippet below:

```ruby
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.infer_spec_type_from_file_location!
end
```

My setup with instance variables looks like this:

```ruby
RSpec.describe User, type: :model do
  before do
    @user = User.create email: 'foo@ombulabs.com', username: 'foofoo'
    @user_2 = User.create email: 'bar@ombulabs.com', username: 'barbar'
  end

  it 'check user username' do
    expect(@user.username).to eq('foofoo')
  end

  it 'check user_2 email' do
    expect(@user_2.email).to eq('bar@ombulabs.com')
  end

  it 'combined test that checks all users' do
    expect(@user.email).to eq('foo@ombulabs.com')
    expect(@user_2.username).to eq('barbar')
  end
end
```

And the setup with `let` would look like this:

```ruby
RSpec.describe User, type: :model do
  let(:user) { User.create email: 'foo@ombulabs.com', username: 'foofoo' }
  let(:user_2) { User.create email: 'bar@ombulabs.com', username: 'barbar' }

  it 'check user username' do
    expect(user.username).to eq('foofoo')
  end

  it 'check user_2 email' do
    expect(user_2.email).to eq('bar@ombulabs.com')
  end

  it 'combined test that checks all users' do
    expect(user.email).to eq('foo@ombulabs.com')
    expect(user_2.username).to eq('barbar')
  end
end
```

So let's run both specs separately and have a look on the output.

```bash
$ bin/rspec spec/models/user_instance_spec.rb
...

Finished in 0.087 seconds (files took 2.87 seconds to load)
3 examples, 0 failures
```

```bash
$ bin/rspec spec/models/user_let_spec.rb
...

Finished in 0.06692 seconds (files took 3.06 seconds to load)
3 examples, 0 failures
```

What we already can see is that the `let`-tests are faster.

If we have a look at the test logs, we can see why that is.

Log output of `user_instance_spec.rb`:

```bash
SQL (2.6ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('foo@ombulabs.com', 'foofoo', '2016-01-22 16:44:42', '2016-01-22 16:44:42')
SQL (0.3ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('bar@ombulabs.com', 'barbar', '2016-01-22 16:44:42', '2016-01-22 16:44:42')
SQL (0.5ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('foo@ombulabs.com', 'foofoo', '2016-01-22 16:44:42', '2016-01-22 16:44:42')
SQL (0.4ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('bar@ombulabs.com', 'barbar', '2016-01-22 16:44:42', '2016-01-22 16:44:42')
SQL (0.3ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('foo@ombulabs.com', 'foofoo', '2016-01-22 16:44:42', '2016-01-22 16:44:42')
SQL (0.3ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('bar@ombulabs.com', 'barbar', '2016-01-22 16:44:42', '2016-01-22 16:44:42')
```

As we can see here, that apparently for each of my tests all records are being created.
This is not the case for `let` examples, if we have a look at the log output.

Log output of `user_let_spec.rb`:

```bash
SQL (0.7ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('foo@ombulabs.com', 'foofoo', '2016-01-22 16:47:45', '2016-01-22 16:47:45')
SQL (0.4ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('bar@ombulabs.com', 'barbar', '2016-01-22 16:47:45', '2016-01-22 16:47:45')
SQL (0.3ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('foo@ombulabs.com', 'foofoo', '2016-01-22 16:47:45', '2016-01-22 16:47:45')
SQL (0.3ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('bar@ombulabs.com', 'barbar', '2016-01-22 16:47:45', '2016-01-22 16:47:45')
```

As we can see in the log output, we count 6 SQL Inserts for the instance example and just 4 SQL Inserts for the `let` example. This is because the variables configured with `let` will be loaded if we directly call them. This behavior is called lazy loading and forgives small mistakes when writing tests.

If we now have a closer look at the instance variable example, you see there the use of `before`. This is the default RSpec behavior and actually translates to `before(:each)`. This means the `before` block gets executed before **every** single test. If you have a really complex test setup in which you use a `before(:each)`, you are most likely wasting a lot of time setting up your tests.

For the next example I'm going to use `before(:all)` to see what changes. So my before block looks now like this:

```ruby
  before(:all) do
    @user = User.create email: 'foo@ombulabs.com', username: 'foofoo'
    @user_2 = User.create email: 'bar@ombulabs.com', username: 'barbar'
  end
```

And the log output of my spec is the following:

```bash
$ bin/rspec spec/models/user_instance_before_all_spec.rb
...

Finished in 0.06128 seconds (files took 3.68 seconds to load)
3 examples, 0 failures
```

My `test.log` gives me the following output:

```bash
SQL (13.2ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('foo@ombulabs.com', 'foofoo', '2016-01-22 16:48:31', '2016-01-22 16:48:31')
SQL (5.2ms)  INSERT INTO `users` (`email`, `username`, `created_at`, `updated_at`) VALUES ('bar@ombulabs.com', 'barbar', '2016-01-22 16:48:31', '2016-01-22 16:48:31')
```

So basically the `before(:all)` block ensures that we are only creating everything inside this **once**. The `before(:all)` can save you some time, when executing tests that need the exact same setup, otherwise I prefer to use the `let` syntax because it's easier to read.

Another great benefit of `let` is the flexible redefinition of variables to change a most likely complex setup.
You just need to change a `let` variable within a context block and you are able to use the exact setup with different variables just by changing one line.

```ruby
RSpec.describe User, type: :model do
  let(:name)    { 'OmbuLabs' }
  let!(:user)   { User.create email: 'foo@ombulabs.com', username: name }
  let!(:user_2) { User.create email: 'bar@ombulabs.com', username: 'barbar' }

  it 'check user username' do
    expect(user.username).to eq('OmbuLabs')
  end

  context 'ombushop username' do
    let(:name) { 'OmbuShop' }

    it 'check user username' do
      expect(user.username).to eq('OmbuShop')
    end
  end
end
```

Benefits with `let`:

  * Lazy loaded variables
  * Faster than `before(:each)`, slower than `before(:all)`
  * Better readability
  * Flexible usage

Benefits with instance variables:

  * Useful for tests that need just one simple setup with a `before(:all)`

Let's sum it up, if your test setup allows it, use instance variables in a `before(:all)` block, otherwise I recommend using `let`.
