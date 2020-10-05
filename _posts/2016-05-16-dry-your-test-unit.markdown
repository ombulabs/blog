---
layout: post
title: "DRY your tests"
date: 2016-05-16 12:31:00
reviewed: 2020-03-05 10:00:00
categories: ["rails", "dry"]
author: "etagwerker"
---

I'm a big fan of having small classes. I'm not a big fan of having huge specs for
a small class/object. Every time I see an opportunity to
[DRY](http://c2.com/cgi/wiki?DontRepeatYourself) my specs, I take it.

Today I wrote a spec to make sure that we gracefully ignore SPAMmy
contact requests in the OmbuLabs
[contact page](https://www.ombulabs.com/contact). It initially looked like this:

```ruby
test "gracefully ignores spammy requests with valid attributes" do
  @valid_contact = contacts(:two)
  attributes = @valid_contact.attributes
                             .merge(email_confirmation: @valid_contact.email)

  assert_no_difference("Contact.count") do
    post :create, contact: attributes, format: 'js'
  end

  assert_response :success
end
```

The new behavior adds a simple [SPAM trap field](http://www.sitepoint.com/easy-spam-prevention-using-hidden-form-fields/)
that bots will usually fall for.
If a bot is submitting the `email_confirmation` field (which is hidden by a CSS
class), then it is **SPAM** and it gracefully ignores the request.

<!--more-->

The test only tests the scenario where the bot is performing an **AJAX**
request. Then I thought that SPAM bots might try to submit a non-AJAX `html`
request.

So I wrote some more:

```ruby
test "gracefully ignores spammy requests with valid attributes (AJAX)" do
  @valid_contact = contacts(:two)
  attributes = @valid_contact.attributes
  attributes.merge!(email_confirmation: @valid_contact.email)

  assert_no_difference("Contact.count") do
    post :create, contact: attributes, format: 'js'
  end

  assert_response :success
end

test "gracefully ignores spammy requests with valid attributes (HTML)" do
  @valid_contact = contacts(:two)
  attributes = @valid_contact.attributes
  attributes.merge!(email_confirmation: @valid_contact.email)

  assert_no_difference("Contact.count") do
    post :create, contact: attributes, format: 'html'
  end

  assert_response :success
end
```

Now that is **ridiculous**, why should I **copy/paste** this? There is only one
parameter (`format`) that varies between them.

So, I [refactored](http://c2.com/cgi/wiki?RefactorMercilessly) the code to
look like this:

```ruby
["js", "html"].each do |format|
  test "gracefully ignores spammy requests with valid attributes" do
    @valid_contact = contacts(:two)
    attributes = @valid_contact.attributes
    attributes.merge!(email_confirmation: @valid_contact.email)

    assert_no_difference("Contact.count") do
      post :create, contact: attributes, format: format
    end

    assert_response :success
  end
end
```

The code above doesn't *really* work. It raises this exception:

    /Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/activesupport-3.2.17/lib/active_support/testing/declarative.rb:28:in `test': test_should_gracefully_ignore_spammy_requests_with_valid_attributes is already defined in ContactsControllerTest (RuntimeError)
    	from /Users/etagwerker/Projects/ombulabs.com/test/functional/contacts_controller_test.rb:29:in `block in <class:ContactsControllerTest>'
    	from /Users/etagwerker/Projects/ombulabs.com/test/functional/contacts_controller_test.rb:28:in `each'
    	from /Users/etagwerker/Projects/ombulabs.com/test/functional/contacts_controller_test.rb:28:in `<class:ContactsControllerTest>'
    	from /Users/etagwerker/Projects/ombulabs.com/test/functional/contacts_controller_test.rb:3:in `<top (required)>'
    	from /Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib/rake/rake_test_loader.rb:10:in `require'
    	from /Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib/rake/rake_test_loader.rb:10:in `block (2 levels) in <main>'
    	from /Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib/rake/rake_test_loader.rb:9:in `each'
    	from /Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib/rake/rake_test_loader.rb:9:in `block in <main>'
    	from /Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib/rake/rake_test_loader.rb:4:in `select'
    	from /Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib/rake/rake_test_loader.rb:4:in `<main>'
    Errors running test:functionals! #<RuntimeError: Command failed with status (1): [ruby -I"lib:test" -I"/Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib" "/Users/etagwerker/.rvm/gems/ruby-2.2.1@ombulabs-com/gems/rake-10.5.0/lib/rake/rake_test_loader.rb" "test/functional/**/*_test.rb" ]>

Basically [test-unit](https://rubygems.org/gems/test-unit) doesn't want
me to define a test with the same description more than once.

So, I decided to interpolate the format variable in the test description:

```ruby
["js", "html"].each do |format|
  test "gracefully ignores spammy requests in #{format} format" do
    @valid_contact = contacts(:two)
    attributes = @valid_contact.attributes
    attributes.merge!(email_confirmation: @valid_contact.email)

    assert_no_difference("Contact.count") do
      post :create, contact: attributes, format: format
    end

    assert_response :success
  end
end
```

Test Unit is happy with this, the tests pass and my spec code is as concise as
possible.

If you prefer [RSpec](https://rubygems.org/gems/rspec), it would look like
this:

```ruby
["js", "html"].each do |format|
  it "gracefully ignores spammy requests with valid attributes" do
    @valid_contact = contacts(:two)
    attributes = @valid_contact.attributes
    attributes.merge!(email_confirmation: @valid_contact.email)

    expect do
      post :create, contact: attributes, format: format
    end.not_to change(Contact, :count)

    expect(response).to be_success
  end
end
```

RSpec is a little smarter than Test Unit and it doesn't require you to
interpolate a variable (`format`) in the description.

Either way, **always** look for ways to keep your tests as *DRY* as your
classes. It will **improve maintenance** in the long run.
