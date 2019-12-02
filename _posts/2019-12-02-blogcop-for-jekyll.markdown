---
layout: post
title: "Blogcop: A GitHub app that helps you manage your Jekyll blog"
date: 2019-12-02 10:30:00
categories: ["github", "jekyll", "ruby"]
author: "luciano"
---

At [OmbuLabs](https://www.ombulabs.com/) we use [Jekyll](https://jekyllrb.com/) to generate our [blog](https://github.com/ombulabs/blog). If you are not familiar with it, here is a quick description from the Jekyll site:

"Jekyll is a simple, extendable, static site generator. You give it text written in your favorite markup language and it churns through layouts to create a static website. Throughout that process you can tweak how you want the site URLs to look, what data gets displayed in the layout, and more."

<!--more-->

## Problem

Jekyll has been working great for us over the years, but one thing that was missing was a way to manage outdated articles. Basically, we wanted the ability to unpublish articles that have not been updated for a few months, so we can review and update them.

## Solution

Since we didn't find any existing tool that does such thing we decided to make our own.

Our blog is hosted on [GitHub](https://github.com/ombulabs/blog) so we thought it would be a good idea to have a [GitHub app](https://developer.github.com/apps/about-apps/#about-github-apps) that does the job. That way anyone can simply install the app in their repo and start using this feature.

#### Blogcop

[Blogcop](https://github.com/marketplace/outdated-article) is a GitHub bot that we built to solve the problem mentioned above.

Blogcop will:

- Be triggered when you push a commit to master.
- Look for articles that have not been updated in the last 3 months (by looking at their last commit date).
- Create an Issue for every outdated article.

<img src="/blog/assets/images/blogcop-issue.png" alt="Blogcop Issue" />


- Create a Pull Request to unpublish every outdated article.

<img src="/blog/assets/images/blogcop-pr.png" alt="Blogcop PR" />

<img src="/blog/assets/images/blogcop-pr-change.png" alt="Blogcop PR change" />

If you are interested you can check the GitHub app's source code in: [https://github.com/ombulabs/blogcop](https://github.com/ombulabs/blogcop).
The bot is a simple [Sinatra](http://sinatrarb.com) app that was built using the [github-app-template](https://github.com/github-developer/github-app-template). If you want to learn more about building GitHub apps I recommend you checking at the [official documentation](https://developer.github.com/apps/building-github-apps).

### Conclusion

If you're currently using Jekyll on your blog or if you were looking for GitHub app examples I hope you find this article useful.

Let us know in the comments section if you have any feedback on this tool.
