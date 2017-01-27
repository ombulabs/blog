---
layout: post
title:  "Announcing AfipBill"
date: 2016-12-14 18:06:00
categories: ["open-source", "rubygems"]
author: "luciano"
---

If you live in Argentina and you ever use AFIP, you should already know that their platform is not the best in terms of user friendly.
One of the things that we wanted to do for [OmbuShop](https://www.ombushop.com) was to access AFIP via [API](http://www.afip.gob.ar/ws) in order to print the bills of each seller. Unfortunately, there is no way to do this because the API doesn't have that kind of scope.

<!--more-->

The old way to print the bills was to access AFIP manually, create the bill and download it. As you may be thinking, this is a very tedious task, specially because we needed to send a monthly bill to each of our sellers.

So, that's why we decided to created this new [Ruby gem](https://rubygems.org/gems/afip_bill). With [afip_bill](https://github.com/ombulabs/afip_bill) you will be able to easily generate a PDF bill for your users. You only need to provide some basic information about your business and your users, and it will automatically complete the whole bill for you, ready to be printed.

You can check the whole code on [Github](https://github.com/ombulabs/afip_bill), as well as the documentation on how to use it.
If you detect a way to improve the codebase, feel free to send us a PR.
