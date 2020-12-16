---
layout: post
title: "Webpack VS Sprockets"
date: 2020-11-13 14:00:00
categories: ["learning", "webpack"]
author: arieljuod
---

Since the release of Rails 6, **Webpack** is the default JavaScript bundler for new Rails app. We all struggle at first coming from a **Sprockets** background, and more often than not, we, as developers, tried to avoid making JavaScript changes so we don't have to deal with it, or just copy/pasted until it worked.

In this post, I'll try to explain some basic concepts and ideas from the point of view of a Rails developer used to work with the Assets Pipeline, comparing how to do the same thing on both.

<!--more-->

## Some Glossary

- A **Bundler** is an application that can process, compile and pack assets like JavaScript, CSS, Images, Videos, etc.
- [Webpack](https://webpack.js.org/) is an bundler that runs on NodeJS.
- [Webpacker](https://github.com/rails/webpacker) is a gem that helps connecting Rails with Webpack.
- [Sprockets](https://github.com/rails/sprockets), like Webpack, is an assets bundler and runs on Ruby.
- [Sprockets-Rails](https://github.com/rails/sprockets-rails) is the gem that connects Rails with Sprockets.
- [Asset Pipeline](https://guides.rubyonrails.org/asset_pipeline.html) is the term used by Rails to refer to the use of Sprockets-Rails to handle assets.

> There are more solutions for this like *Rollup*, *Parcel* or *Browserify*. I won't cover those here.

## Directories Structure

When using Sprockets, you typically have all the assets at `app/assets`, and, inside that folder, you have `stylesheet`, `images`, `javascript`, etc. You usually have all your assets in the root of each of those folders or inside nested folders too.

When using Webpack, in a standard Rails app you have all the JavaScript at `app/javascript`. This is the default, but if you plan to manage all your assets using Webpack (CSS, images, etc) or you simply want a different folder, you can change that to something like `app/webpack` in `config/webpacker.yml`:

```yml
  source_path: app/webpack
```

You usually have all your assets inside `app/javascript` or `app/javascript/src` and only the **main** JavaScript files inside `app/javascript/packs`.

> You could also have `app/javascript/css` or `app/javascript/images` for example to organize other asset types. Then it would be a good idea to rename the `source_path`.

## Packs

When you start using Webpacker, one of the first things you need to do is to replace the `javascript_include_tag` with `javascript_pack_tag`. Same applies for the css using `stylesheet_pack_tag` instead of `stylesheet_link_tag`.

> Note that, by default, Rails will use Sprockets for the CSS and Webpack for the JS, so you will have `stylesheet_link_tag` and `javascript_pack_tag` in your application layout, but you can still use the other helpers if needed

Similar to `javascript_include_tag` that links to a file compiled at `public/assets/`, `javascript_pack_tag` will link to a file compiled at `public/packs`. You can also configure that in `config/webpacker.yml`:

```yml
  public_root_path: public
  public_output_path: packs
```

## Multiple Packs

When using Sprockets, you have to tell Rails which JavaScript and CSS assets will be created from all the sources we have (defaults are `application.css`, `application.js` and all other asset file type). You do that with an initializer (for example, at `config/initializers/assets.rb`):

```ruby
# config/initializers/assets.rb

Rails.application.config.assets.precompile += %w( admin.js admin.css )
```

To do the same with Webpack, you don't need to change a configuration. All the files at `app/javascript/packs` (AKA "the entry points") will be created (AKA "emitted"). You can change where your packs are located too in `config/webpacker.yml`:

```yml
  source_entry_path: packs
```

By default, you have an `application.js` file there, but you can add an `admin.js` one too for example:

```js
// app/javascript/packs/admin.js

// here you can add all your code or require other files
```

Now, when Webpack compiles your assets, it will emit `application.js` and `admin.js`.

You can also create a `.css` (or `.scss` if you prefer) file to be emitted:

```sass
// app/javascript/packs/admin.scss

@import some_sass_module // you can use SASS imports
```

And now Webpack will also process, compile and emit an `admin.css` file.
> There's a caveat when using a CSS pack, I'll comment that later when I talk about images

> Note that **ALL** the files under `/packs` will be emitted. You don't want to put all your source files there, but only the ones you are going to access directly! All your source files should be at the parent folder or at a sibling folder.

## Node Modules

Rails uses [YARN](https://yarnpkg.com/) by default to handle Node packages. All packages are downloaded in a `node_modules` folder in the root of your project.

> Remember to add that folder to the `.gitignore` file, you don't want to push all these files into your repo

These packages can be used by both Sprockets and Webpack, so you can use the same package to provide some CSS for your stylesheets using Sprockets and some JavaScript for your scripts using Webpack.

If you want Sprockets to look for files inside that folder, you need to add that to the assets paths list:

```ruby
# config/initializers/assets.rb

Rails.application.config.assets.paths << Rails.root.join('node_modules')
```

Webpack will look for files there by default, so no change needed, but if you want to tell Webpack to check other folders too you can add paths to the `additional_paths` configuration at `config/webpacker.yml`.

Now, when you `require` or `import` in a JavaScript file, `@import` on an SCSS file or `// require` on a CSS file, the compilers will look for a folder with the name we used there on any asset path. When we see a line like this:

```js
require('@rails/ujs').start()
```

It is looking for a module at `node_modules/@rails/ujs`, and it checks the `package.json` file inside that folder to know what to load. You can also reference specific files instead of a module, for example, the `@rails/ujs` package's `package.json` file has this line:

```js
  "main": "lib/assets/compiled/rails-ujs.js",
```

That is the file that will be used if referencing `@rails/ujs`, but you could also be specific and do:

```js
require('@rails/ujs/lib/assets/compiled/rails-ujs.js').start()
```

With the same result.

This is really helpful when you want to customize what you import to reduce the size of your bundles.

## Global JavaScript Functions

Let's say you have this JavaScript file:

```js
function initMap(mapId) {
  // initializes a map plugin
}
```

Let's say you want this function to be available from anywhere, because you call that during the page load but also from some AJAX response.

When using Sprockets, all JavaScript is concatenated in one plain file and everything runs in the global scope. So you can call `initMap` from anywhere by default. This is really handy... BUT! there's is a problem: it bloats the global scope and you can have different modules using the same function causing name collision.

When using Webpack, each script is isolated so nothing changes the global scope by default and only exports the things you tell it to export (it could be a class, a function, an object, etc..., we can export multiple things too). This solves the problem of global scope contamination, but you won't be able to access the `initMap` function from anywhere since it's not exposed globally.

To do that, you have to be explicit when defining the function in your module:

```js
global.initMap = function(mapId) {
  // initializes a map plugin
}

// or

const initMap = (mapId) => {
  // initializes a map plugin
}
global.initMap = initMap

```

## jQuery

Many projects depend on **jQuery** and needs the `$` function available everywhere. The easiest way to handle this is to tell Webpack to expose the `$` and the `jQuery` functions globally. To do that, you need to add a plugin setting:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment
```

## Livereload

Webpacker comes with a handy bin file you can run to make your web auto-reload when you change any asset, so you don't have to refresh manually after each change you do. You can run `rails s` in one terminal and `bin/webpack-dev-server` in another terminal, enter `localhost:3000` and you can change any asset and your page will be updated with no need of `F5`. This is really handy when you need to do heavy assets work.

## Non-JavaScript Assets With Webpacker

### CSS

When using Webpacker, while you can have CSS entry points at `app/javascript/packs`, it can create some problems and sometimes you will see something like this inside a JavaScript file instead:

```js
import 'my_file.css';
```

or even more strange-looking:

```js
import 'my_image.png';
```

What's happening here is that Webpacker can extract different type of assets referenced by your JavaScript packs and emit those as separated files! If you have an `application.js` file that imports some CSS, it will emit an `application.css` file with the content of that CSS. You have to be sure you have the right configuration:

```js
// config/webpacker.yml

production:
  extract_css: true
```

You can have that as `false` during development or testing, but it's needed for production. I'd recommend you at least try with this as `true` during development to verify it will create the right files for production.

### Images

If you open your `application.js` file, you will find this comment:

```js
// packs/application.js

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
```

You can tell Webpack to compile and emit all the files at `../images` un-commenting the first line:

```js
// packs/application.js

require.context('../images', true)
```

Now you can put all your images in `app/javascript/images` and Webpack will move them to `public/packs/media/images` during compilation. You can check at `config/webpacker.yml` which `static_assets_extensions` it supports (many image and font types by default). You can add more extensions there to support more file types.

You can reference assets from your `erb` templates using the `asset_pack_path/url` and `image_pack_path/url` helper methods provided by Webpacker.

> Note that for this configuration to work you must NOT have an `application.css` pack! There is an [open issue](https://github.com/rails/webpacker/issues/2144#issuecomment-745745635) in Webpacker's repo.

### Wrapping up

A simple basic configuration to handle JS, CSS, Images and Fonts using webpacker could be:

```
app
  |_ javascript
    |_ packs
      |_ application.js
    |_ src
      |_ some_javascript.js
    |_ stylesheets
      |_ application.css
    |_ images
      |_ logo.jpg
      |_ test.png
    |_ fonts
      |_ myfont.ttf
```

And your `application.js` would look like this:

```js
// packs/application.js

import '../stylesheets/application.css'
require.context('../images', true) 
require.context('../fonts', true)

// and now your JavaScript ...
import SomeModule from '../src/some_javascript'
```

You can rename the `source_path` to `assets` and use `javascript` instead of `src` and it will look pretty similar to the Assets Pipeline!

## Pros And Cons

So, what should you use? Sprockets? Webpack? Both? As always, the answer is... it depends. By default, since Rails 6, it uses both: Webpack for JavaScript, Sprocket for any other asset. According to your needs, you may want to use one or the other or change which assets you handle with each of them. You can even handle assets of the same type using both solutions at the same time!

Let's do a quick comparison:

### Sprockets Pros
- As Rails developers, we are really used to how the asset pipeline works and many Rails specific guides may reference this instead of Webpacker (mainly older guides before the Rails 6 release)
- You can use assets from gems AND from node_modules

### Sprockets Cons
- There are no plans for make it work with modern JavaScript features ([According to DHH](https://discuss.rubyonrails.org/t/webpacker-presents-a-more-difficult-oob-experience-for-js-sprinkles-than-sprockets-did/75345/9))
- Bloats the JavaScript global scope
- It's not the default for JavaScript, so new guides will be focused on Webpack

### Webpack Pros
- Gives you access to all modern JavaScript features
- Gives you access to a lot of plugins to handle the compilation process
- Easy setup for JavaScript frameworks (like React, Vue or Stimulus) when creating Rails apps
- Does not populate the global scope unless we are explicit
- Includes an auto-reloader during development
- There are many resources for Webpack in general (not specific to Rails) that also apply

### Webpack Cons
- You can (and should) import CSS files (and other asset types) inside JavaScript files, which may be confusing at first
- From my experience, you can't read assets from gems (documentation states that you can use assets from Rails Engines, but I was not able to set that up)

## Conclusion

After this comparison, I think the general approach of using Webpack for JavaScript files and Sprockets for the rest is the way to go for now. It enables JavaScript modern features using Webpack but leaves the other assets to be handled by Sprockets so the learning curve is not as pronounced for developers used to the Assets Pipeline. And at the same time it's also capable of handling all the assets types using Webpack for developers experiences with Webpack that comes to Rails.

Some resources to keep watching and reading:
- Webpacker docs: https://github.com/rails/webpacker/#docs
- Survival guide for Rails devs: https://www.youtube.com/watch?v=ivQ7HrnBJe8
- Webpack vs Sprockets: https://www.youtube.com/watch?v=2v4ySqyua1s
