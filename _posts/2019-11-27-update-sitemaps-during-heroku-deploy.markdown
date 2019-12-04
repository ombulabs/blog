---
layout: post
title:  "Update sitemaps with dynamic content"
date: 2019-11-27 12:00:00
categories: ["seo"]
author: "cleiviane"
---

A few months ago I received the task of making the [FastRuby.io](https://www.fastruby.io) sitemap refresh automatically after each deploy. That sounds like it would be pretty straightforward if we didn't have one issue (it's never that easy, right?). For the [FastRuby blog](https://www.fastruby.io/blog) we created a gem that encapsulates a Jekkyl application. The discussion of why do we have a gem for our blog is actually a good topic for a new post. For now, I want to focus in the sitemap task that I had.

Since the blog is a gem, we also need to make sure that whatever tool we use to generate the sitemap covers new blog posts.

In this article I'll show you my journey to figure out how to make everything work together.

<!--more-->

## First of all: what is a sitemap?

According to [Google](https://support.google.com/webmasters/answer/156184?hl=en) itself:
> "A sitemap is a file where you provide information about the pages, videos, and other files on your site, and the relationships between them. Search engines like Google read this file to more intelligently crawl your site."

It tells to search engines which pages and files you think are important in your site, and also provides valuable information about these files: for example, when the page was last updated, how often the page is changed, and others.

So it's important to keep it always up-to-date.

## Configuring the Gem

Listing all routes of a website and add them to a XML file seems to be a repetitive task, so I thought that we might have a gem for it already. And we do. It's the [`sitemap_generator`](https://github.com/kjvarga/sitemap_generator) gem, which does exactly what we need: provide a few rails tasks to generate and refresh the application sitemap.

Installing the gem is pretty easy, just add it to your `Gemfile`:

`gem 'sitemap_generator'`

run the `bundle install` and then run this task:

`rake sitemap:install`

that will create a config file with some information to be used by the gem, like the sample below:

```
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://example.com'
SitemapGenerator::Sitemap.create do
  add '/home', :changefreq => 'daily', :priority => 0.9
  add '/contact_us', :changefreq => 'weekly'
end
```

As you can see, inside the `Sitemap.create` block we need to add all routes of our site.

If your site has only static content, your job here it's done. You just need to use the rails task from the sitemap_generator itself `rake sitemap:refresh` and a `sitemap.xml` file will be added to the `public` folder.

But in my case new routes will be added every time that someone writes a new article. And as we know, the blog it's a Jekyll application,
so we can't get the routes using the rake task provided by the `sitemap_generator` gem.

## Generating the sitemap index

To solve this issue, my idea was to change the `sitemap_generator` config to instead of generate just one `sitemap.xml` file, it would create two sitemaps (one for the blog and one for the website) and add them to a index file.


This is how the `config/sitemap.rb` file needs to be changed:

```
blog_sitemap_opts = {
  create_index: false,
  default_host: 'https://fastruby.io/blog',
  compress: false,
  sitemaps_path: '',
  namer: SitemapGenerator::SimpleNamer.new(:blog_sitemap)
}

SitemapGenerator::Sitemap.create blog_sitemap_opts do
  pages = Dir["public/blog/**/*.html"]
  pages.each do |blog_page|
    add blog_page, changefreq: 'weekly'
  end
end

sitemap_opts = {
  create_index: false,
  default_host: 'https://fastruby.io',
  compress: false,
  sitemaps_path: '',
  namer: SitemapGenerator::SimpleNamer.new(:sitemap)
}

SitemapGenerator::Sitemap.create sitemap_opts do
  add '/#contact-us', changefreq: 'weekly'
  add '/team', changefreq: 'weekly'

  # all other important page here

  add_to_index "blog_sitemap.xml", host: ENV['SITE_URL']
end

```

As you can notice, in the first `SitemapGenerator::Sitemap.create` block we are listing all files inside the `blog` folder and adding their path to the blog_sitemap file.

After that we are generating the `sitemap` for the website itself, listing all important pages and adding the `blog_sitemap` to the index.

You can see the sitemap index file resulted by this config [at this link](http://fastruby.io.s3.amazonaws.com/sitemap.xml). It would be like this:

```
<sitemapindex xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd">
  <sitemap>
    <loc>http://fastruby.io.s3.amazonaws.com/blog_sitemap.xml</loc>
    <lastmod>2019-12-02T17:54:36+00:00</lastmod>
  </sitemap>
  <sitemap>
    <loc>http://fastruby.io.s3.amazonaws.com/sitemap1.xml</loc>
    <lastmod>2019-12-02T17:54:36+00:00</lastmod>
  </sitemap>
</sitemapindex>
```

## And this is it!

We know that for a better SEO, it is important to have a `sitemap` file. But since this is a static file sometimes it's a little tricky to keep them updated. So I just described my solution for that issue.

What about you? Do you use a different strategy? Let me know in the comments!
