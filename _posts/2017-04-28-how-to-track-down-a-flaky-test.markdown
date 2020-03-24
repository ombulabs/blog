---
layout: post
title:  "'Flaky' tests: a short story"
date: 2017-05-04 11:02:00
reviewed: 2020-03-05 10:00:00
categories: ["rspec", "continuous-integration"]
author: "mauro-oto"
---

One of the hardest failing tests to debug are those which fail randomly, also
known as __"flaky"__ tests. You write your test cases, you run the tests in your
environment (in random order), and see them all pass. Afterwards, you push your
code, your CI server runs them and _one test fails_.

This is not an uncommon scenario, and one _too common_ when using integration
tests which use JS, with `Capybara-Webkit` or `Selenium`.
But if your failing test doesn't communicate with an external API, doesn't use
JS, and passes locally, it can be a bit nerve-wracking.

After you have identified the failing test, and it still passes after running it
locally, one way to figure out __why__ it's failing is running its context
multiple times.

To automate this process a bit, I like to use the following command:

<!--more-->

```bash
for i in {1..10}; do rspec spec/controllers/v7/users_controller_spec.rb:205; done
```

It will run your test 10 times in a row, and _hopefully_ you might see the
test fail once or twice. RSpec's feedback should provide some insight into why
the failure occurred. Otherwise, what I like to do before running the command is
add `puts` statements before the expectations.

If your expectation is:

```ruby
expect(response.body).to eq(json)
```

a good thing to do would be to change that to:

```ruby
puts "*" * 80
puts "actual response: #{response.body}"
puts "*" * 80
puts "expected response: #{json}"
expect(response.body).to eq(json)
```

(See also: [I am a puts debuggerer](https://tenderlovemaking.com/2016/02/05/i-am-a-puts-debuggerer.html))

Now when your test fails, you'll be able to see what the contents of the
compared variables were.

In my case, the last time I faced this (which prompted me to write this article),
the test did not fail locally, _even after 20 runs_. I went back into the CI server,
and noticed the tests' order _was not randomized_.

```bash
for i in {1..10}; do rspec spec/controllers/v7/users_controller_spec.rb:205 --order defined; done
```

By adding `--order defined` I was able to track down the flaky test and fix it.
On one hand, it's good the CI caught it because the build is always randomized in
my environment, and one day the test suite would "randomly" be in order and fail.
On the other, this made me realize that I needed to update my `yml` config for
the CI server to _randomize the tests_ by explicitly using `--order random`.

The `--seed 1234` option also exists in RSpec, so if your tests in the CI already use
random ordering and you get a flaky test, you can run:

```bash
rspec spec/controllers/v7/users_controller_spec.rb:205 --seed 1234
```

and it will use the seed provided by you, obtained from the failing
test log on the CI server.

Re-running failing tests has been brought up in the [RSpec repo](https://github.com/rspec/rspec-core)
[a couple](https://github.com/rspec/rspec-core/issues/456)
[of times](https://github.com/rspec/rspec-core/issues/795) in the past.
Some alternatives like [respec](https://github.com/oggy/respec) exist, but it
might not be worth it to add to a project as it's not something that happens too
often.

Depending on your CI server, you may also be able to configure re-runs
using your `yml` config file, in case your flaky tests are persistent. We have
been using [Solano CI](https://ci.solanolabs.com) for a while and by using:

```yaml
rerun_list:
  - spec/benchmarks/controllers/v7/users_controller_spec.rb: 2
```

the test runs at least two more times if it fails on the first run, to ensure
that the entire build doesn't fail because of _that one pesky_ test.
