---
layout: post
title:  "Announcing AfipBill"
date: 2017-02-09 15:06:00
categories: ["open-source", "rubygems"]
author: "luciano"
---

If you live in Argentina and you ever use AFIP, you should already know that their platform is not the best in terms of user friendliness.
We wanted to integrate [OmbuShop](https://www.ombushop.com) with AFIP (using their [API](http://www.afip.gob.ar/ws)) in order to generate and print the bills for each seller. Unfortunately, there is no way to do this because the API doesn't generate a printable version (PDF) of the bill.

<!--more-->

The old way to print the bills was to access the AFIP website, create the bill and download it. This is a very tedious task, specially because we needed to send a monthly bill to each of our sellers.

That's why we decided to create this new [Ruby gem](https://rubygems.org/gems/afip_bill). With [afip_bill](https://github.com/ombulabs/afip_bill) you will be able to easily generate a PDF bill for your users. You only need to provide some basic information about your business and your users, and it will automatically complete the whole bill for you, ready to be printed.

You can check the whole code on [Github](https://github.com/ombulabs/afip_bill), as well as the documentation on how to use it.
If you detect a way to improve the codebase, feel free to send us a PR.
