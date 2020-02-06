---
layout: post
title: "10 Steps to Evaluate a Rails Project"
date: 2016-02-17 13:55:00
categories: ["rails","maintenance"]
author: "etagwerker"
published: false
---

It will come a time when you will have to decide whether to maintain a [Rails](http://rubyonrails.org) project **or not**.

If you want to seriously consider it, you should follow these 10 steps:

### 1. Setup the development environment

Git clone the repository and try to start the server. Is the `README` clear enough? Can you follow the steps in the file and easily get started?

A lot of projects will have a `README` that is out of date and/or instructions that don't work right off the bat.

Most of the projects will define guidelines like these:

* Configure your `config/database.yml`
* Configure your `.env` file
* Setup the database `rake db:create db:migrate db:seed`
* Start the server `rails server`

The best projects will have a one-liner that will setup the entire environment for you.

<!--more-->

For example:

```bash
cd path/to/project
./bin/setup
rails server
```

### 2. Run the tests

Once you have setup your development environment, try to run the tests. For example:

```bash
rake
```

Any decent [Rails](http://rubyonrails.org) project will have a passing build, even if it's not very thorough.

Hopefully, the build won’t take more than 10 minutes to finish. Some builds will take a long time, especially if they include integration tests (e.g. Integration tests that use the [Selenium](http://www.seleniumhq.org) driver)

Did the build pass? Did it fail? How many failures did you get?

In the best case scenario, the tests will pass.

### 3. Review schema.rb

A good way to see the complexity of an application is to see the amount of tables in the database. Does it have more than 20 tables? More than 100? Can you easily draw an [ERD](https://en.wikipedia.org/wiki/Entity–relationship_model) of the core models? Are the tables normalized?

I like doing the exercise of drawing the core business tables and the relationships between them. This usually helps me understand the business behind the project.

### 4. Review .env

Does the project have a `.env` file or similar? If the project doesn’t have one, it’s a clear sign that there will be trouble moving the project across environments (development, test, staging, production)

By now we should all know that [we should all be using environment variables](http://12factor.net/config). If someone developed this project without *env* variables, you will probably find condition statements for this problem all over the codebase.

### 5. Check the Gemfile

Find out the project's [Rails](http://rubyonrails.org) version. Is it the latest version? Is it older than 3.0?

One thing that we’ve learned is that upgrading Rails in a project is **not a walk in the park**.

Does it use gems that are not currently maintained? This could be a sign that you will have to migrate to new gems, which will produce extra work and affect your estimates.

### 6. Run bundle-audit

[Bundler Audit](https://rubygems.org/gems/bundler-audit) is a useful gem that will check for known vulnerabilities for the gems specified in `Gemfile.lock`

If there are any vulnerable dependencies, this tool will suggest that you upgrade to a patched version of the gem.

In the best case scenario, you will see something like this:

```bash
etagwerker:ombushop/ (master) $ bundle-audit
No vulnerabilities found
```

### 7. Setup Code Climate

This is a quick (and **paid**) step to check code quality. At [Ombu Labs](https://www.ombulabs.com) we have a business account that we use for our products and our client's projects.

[Code Climate](https://codeclimate.com) is a paid service that does automated code review for test coverage, complexity, duplication, security, and style.

You can quickly find **code hotspots**, potential issues, potential bug risks, and even coverage stats.

What is the [GPA](https://docs.codeclimate.com/docs/ratings) of the project? 4.0? 1.5? This will give you an overall idea of the complexity within the project. 4.0 is the best you can get!

A free alternative would be to run some (or all) of these tools on the project:

* [flog](https://rubygems.org/gems/flog)
* [flay](https://rubygems.org/gems/flay)
* [metric_fu](https://rubygems.org/gems/metric_fu)
* [simplecov](https://rubygems.org/gems/simplecov)

### 8. Check code coverage

As much as I like [Code Climate](https://codeclimate.com), [simplecov](https://rubygems.org/gems/simplecov) is an even faster way to generate a quick report about code coverage.

This tool will tell you the coverage percentage for each application layer. How much percentage is covered in the models' tests? How much for the controllers' tests?

Which are the least covered files? How many relevant lines are in each file? How many of them are covered by a test?

The overall test coverage percentage will give you an idea about how much past developers cared about tests.

If you are going to be changing the code, you need to make sure that this code is covered. If not, it will be a nightmare!

You should complement this report with a qualitative code review of the tests, to make sure that the coverage is actually thorough.

### 9. Research the development process

Do the developers have a process to introduce changes to the project? Do they use code reviews before they merge anything to `master`? Do they have a [CI](https://en.wikipedia.org/wiki/Continuous_integration) service that runs with every pull request? Do they even use pull requests?

What's in the roadmap for the next 3 months? Is this project **on fire**? Do they need a firefighter? Why is it on fire?

### 10. Review performance stats

Do they use [Skylight](https://www.skylight.io/r/qGCIS90vk2nD)? [NewRelic](http://newrelic.com)? What are the slowest and busiest requests? What are the main performance problems?

Most projects won't have information from these (**paid**) services. So you will have to find out on your own. If they use [Google Analytics](https://www.google.com/analytics/), you might find some information about poor page performance.

## Conclusion

These are the steps that we currently follow before we take over a Rails project. They've been quite helpful for us. I recommend that you use them to judge the quality of the project as objectively as possible.

Project maintainers, product owners and founders won't know the state of the code. You can't trust their opinion.

At [Ombu Labs](https://www.ombulabs.com), if all these steps **pass** we will be happy to take over the project. If most of them **fail** we will usually send the company a **free** code quality report and respectfully decline.

I would love to know your opinion about these steps. Do you have other steps that you would recommend? Let me know!
