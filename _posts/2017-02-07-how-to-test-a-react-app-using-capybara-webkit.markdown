---
layout: post
title:  "How to test a React app using capybara-webkit"
date: 2017-02-07 13:52:00
categories: ["rails", "react"]
author: "mauro-oto"
---

I have been using the [capybara-webkit](https://github.com/thoughtbot/capybara-webkit)
gem for a while now since I first tried it out after making the switch from
Capybara + Selenium.

Using capybara-webkit speeds up my Selenium tests due to its headless nature,
and it's very straightforward. However, I had some trouble testing a
[Rails](http://rubyonrails.org) based React app.

In this post, I will explain how I worked around the issues that came up when
trying to use capybara-webkit with [React](https://facebook.github.io/react).

<!--more-->

capybara-webkit depends on [Qt](https://www.qt.io), which you can install on
OSX using [Homebrew](http://brewformulas.org/Qt).
When running the tests using capybara-webkit with Qt 4.8, I noticed nothing was
getting rendered. To debug this problem, I used capybara-webkit's [debug mode]( https://github.com/thoughtbot/capybara-webkit#configuration),
which spits out problems you would usually see in the Chrome console.
To enable it:

```ruby
Capybara::Webkit.configure do |config|
  # Enable debug mode. Prints a log of everything the driver is doing.
  config.debug = true
end
```

When the test runs, you'll get a log of every request/response and JS errors
that happen during the test. One of the errors I got was:

```
ReferenceError: Can't find variable: React
```

After some googling, I found [this issue](https://github.com/reactjs/react-rails/issues/10#issuecomment-57300387).
Because I was using Qt 4.8, I needed [es5-shim](https://github.com/es-shims/es5-shim/blob/master/es5-shim.js)
on my vendor Javascript directory, and include it on the manifest before
including React, like so:

```
//= require jquery
//= require jquery_ujs
//= require es5-shim
//= require react
//= require react_ujs
```

This happens because Qt 4.8's QtWebKit doesn't support most of the ES5 standard.
As an alternative to es5-shim, you can upgrade to a newer version of Qt, like
5.5, which does support some of the newer Javascript features.

After upgrading to Qt 5.5 and re-installing capybara-webkit, you can try getting
rid of `es5-shim` from your pipeline, and your tests should pass.

If you are using any of the [ES6 features](http://es6-features.org,), you'll
notice that your tests will fail even using Qt 5.5, because ES6 is not yet
supported by Qt 5.5.

When using `Object.assign` for merging objects to pass to my React state, I was
getting this error:

```
TypeError: undefined is not a constructor (evaluating 'Object.assign(...)') ...
```

To fix it, I used the polyfill provided by Mozilla in their MDN documentation
for [Object.assign](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign).
But if you prefer, you can include the whole [es6-shim](https://github.com/paulmillr/es6-shim)
library and not worry about including each individual polyfill.

After all this, my tests finally passed!

Disclaimer: I used the [react-rails](https://github.com/reactjs/react-rails)
gem. If you are already using [Webpack](https://webpack.js.org) in your
Rails app, using [babel-loader](https://github.com/babel/babel-loader) or
similar plugins to allow [transpiling](https://scotch.io/tutorials/javascript-transpilers-what-they-are-why-we-need-them)
of ES6 would make these problems go away.

Have you had any problems getting your React integration tests running? Let me
know in the comments section below.
