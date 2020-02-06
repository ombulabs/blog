---
layout: post
title:  "The Manual Tester: Becoming the Best QA Asset For Your Team"
date: 2019-10-28 08:00:00
categories: ["software-development", "software-quality"]
author: abizzinotto
published: false
---

No app is flawless. We all know that. Quality Assurance is an important part of any software development process and the better the tester, the higher quality the software that gets deployed to production.

But… how to be a better manual tester? Applications have evolved greatly and are becoming more and more powerful, but the manual testing process stays pretty much the same. So what is it that will make you stand out?

Here at [OmbuLabs](https://www.ombulabs.com) we have some techniques that we employ that ensure our high satisfaction rates. In this post, we’ll share some tips with you.

<!--more-->

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">A QA engineer walks into a bar. Orders a beer. Orders 0 beers. Orders 99999999999 beers. Orders a lizard. Orders -1 beers. Orders a ueicbksjdhd. <br><br>First real customer walks in and asks where the bathroom is. The bar bursts into flames, killing everyone.</p>&mdash; Brenan Keller (@brenankeller) <a href="https://twitter.com/brenankeller/status/1068615953989087232?ref_src=twsrc%5Etfw">November 30, 2018</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

##So… How do I become a better Manual Tester?

Anyone with common sense, empathy and basic knowledge of computer applications can run manual tests. But to ensure quality tests are being run and quality bug reports are being produced, there are certain things that need to be observed.

####1. You’re not the one coding:
Developers have a development mindset. They are focused on solving problems, not creating them and, of course, they are influenced in their tests by the thought process they used to code the application / feature / bug fix. So although it is important for developers to test their own code, if you’re the person responsible for the QA gate of the software development, it is important that you have a tester’s mindset. You’re there to find problems. So make sure you are not involved in the coding process of what you’ll be testing.

####2. Know your end user. And know them well:
Every project is different. The software produced will have different features, different end users. So it’s important that you take the time to know your end user well. Answering the following questions will put you in the right place to “play user” when it’s time to test.

*Who is the end user?*
*What problem are they trying to solve?*
*Is there more than one category of end user that’ll be interacting with the software?*
*How will those interactions be different?*
*What sections of the software will different end user categories interact with?*
*How technical is my end user?*

To answer these questions, talk to your Scrum Master / Project Manager and also with the Product Owner. Make sure you understand enough to approach the application from the correct perspective.

####3. Know your software:
This is just as important as knowing your end user. Every application is built to solve a specific problem and has its limitations. You don’t need to have a deep understanding of what goes on under the hood, but make sure you know the specifications of the software, what it is supposed to do and within what boundaries. We all have different ideas for features and things an application *could* do. But if we’re going to add all of those, no software would ever be concluded. So what is it that the software doesn’t do **by design**?

####4. Be organised:
Organisation is key. First of all, organise your end user knowledge. If you have multiple end user categories, create a table, define rows for each category and columns for each question and make sure you have all the necessary “profiles” before you start testing.

Additionally, organise your tests. Create different folders for each section you’re testing (especially for large tests, like release tests) and write a report. Make sure you approach the application in an organised fashion and store relevant videos, screenshots and notes in the specific folders. When you write your report, it is important you can refer back to these to find the information you need.

####5. Be in the right mindset:
Before starting any testing project, make sure you are in the right mindset. A few tips to get you there:

1. **Start by not testing.** Open the application, put yourself on an “empty” mindset and play with the app like you’re a user without any previous knowledge of it and just play around. See what you can do, how the app behaves and how it flows.
2. **Never approach an application like it’s flawless.** Always go in expecting to find bugs. That could mean the difference between ignoring something assuming it’s a quirk and reporting a bug that otherwise would end up in production.
3. **Create problems.** You are here to push the limits of the app. To find what can break it. Not what it can do, the developers took care of that. Your job is to find the edge cases, the action paths that cause it to behave unexpectedly.
4. **Expect the app to fail.** But to fail gracefully. Obviously, there will be things that the software simply wasn’t designed to handle. That happens on every project. But is there an action path a user can follow that will result in one of those situations? And, if there is, does the software fail gracefully? That is, does it display a nice failure message instead of just spitting out a lot of techie stuff that looks like alien talk to someone not well versed in code?
5. **It’s not personal.** Remember that you are testing the application. And that you’re pushing its limits. You’re not testing the developer. It’s vital to be impartial and approach the application free of any emotions or preconceived ideas.


####6. Have the right test scope:
What kind of test are you running? You can usually group tests in two main categories: unit tests and release tests. The first, you’ll run whenever a story is finished and ready to be marked as done. The second, whenever the sprint ends and you have something to demo. Make sure you are clear on which one you’re running.

####7. Define test cases clearly:
Before starting any testing project, define clear test cases.

If you’re testing a single user story, go back, review the story description and any pre-defined manual tests. Make sure you understand how that fits in the software but also the limits of that story. Then define the flows the user would follow. Now, define alternate flows you could follow to achieve the same results. Then write test cases based on that.

If you’re doing a release test, take the time to go back and review all stories in that release. Then understand how the user would interact with the product, define the necessary flows, define alternate flows, and write test cases based on that. But don’t limit yourself to the test cases you’ve written. Also take the time to run exploratory tests. Go through everything in the application the release has affected and take the time to click around and play with the app.


####8. Produce detailed bug reports:
Your bug report is what’ll tell the development team what is going wrong, how did you get it there and, most importantly how to fix it. But it should also give the team enough information to decide whether it’s something that needs to be fixed / added / taken care of or edgy enough that it doesn’t justify the time and resources spent on it and, thus, should just fail gracefully.

Some tips to make sure your bug reports always provide good information:

1. Describe the issue in a clear manner.
2. Note down the steps to reproduce the issue.
3. Note down the details of the browser, system and device used to cause the failure.
4. Describe why would a user do that. Why would anyone follow those specific steps to get that result?
5. Describe why it’s important to fix that.
6. Add videos and screenshots of the issue. Especially if it’s something you can reproduce, a full-screen video of the steps you followed and the result obtained can be very useful.

####9. Always ask questions:
Testing is a process and one that involves many parts. First of all, ask yourself questions. Some of the important ones are:

1. **Have I tested anything similar before?** If the answer is yes, this can be both helpful and harmful. It’s helpful to go back and review the previous test cases and see what you can take from that. But each project is different. So make sure you do that at the end of the process so you’re not biased.
2. **What questions am I trying to answer?** There are a million things you can test for. Make sure you know what answers you need to provide to apply the correct techniques and run the proper cases.
3. **What kind of end user am I mimicking?** Make sure you have enough information about your end user and you know how to mimic their behaviour.

Also ask the product owner and your dev team questions. Make sure you understand what the application needs to do, why and how. Also make sure you understand what the limitations are and what previous decisions have been made in terms of scope.

####10. Make sure you have the right tools

Yes, even for manual testing. The application you’re testing will likely need to work on a variety of devices and will definitely need to work on different browsers and systems. Do you have the right tools to make sure the test is comprehensive enough?

Make sure you talk to the product owner and the dev team and understand in which environments your application needs to work. Windows and Mac? Chrome, Firefox, Internet Explorer, Safari? iPads and Android tablets? iPhones and Android phones?

It’s important to make sure the behaviour is the desired one in all target environments.

##Conclusion

The better the manual tester, the higher quality the result. So make sure you follow these tips and:

1. Know your software and your customers well.
2. Get in the right mindset.
3. Define the scope of the test and organise your tests.
4. Ask questions and make sure you have all the necessary tools.
5. Produce detailed bug reports and remember, it's not personal!

Happy testing!
