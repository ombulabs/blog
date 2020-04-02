---
layout: post
title:  "How We Helped Predictable Revenue Scale"
date: 2017-08-22 8:06:00
reviewed: 2020-03-05 10:00:00
categories: ["case-study"]
author: "etagwerker"
---

A few weeks ago I had the opportunity to talk to [Preston St. Pierre](https://www.linkedin.com/in/tarential), CTO of [Predictable Revenue](http://predictablerevenue.com). We worked with Preston and his team for 2 years to help them scale their software development.

<!--more-->

**Ernesto:** First of all, thanks for taking the time to talk to me. I have a few questions about our past engagement. Let's start with this one: **What was the main problem you were having when you hired us?**

**Preston:** I suppose the main problem was lack of developer hours. We needed somebody that was flexible, on time, that we could hire for more hours or less hours if we had the budget.

But the part that we didn't realize that we needed was that there was no real structure to our development, being just Francesco and I. We'd discuss the problem, decide what to do, and that was kind of it. You gave us a number of processes and principles that we used to start our growth towards a more traditional organization for engineering. It didn't affect us much at the time, but it sure helped us later on as we added more developers.

**Ernesto:** That's great to hear. **And how did that impact the business for Predictable Revenue?**

**Preston:** [Ombu Labs](https://www.ombulabs.com) was a significant part of our development team for over two years. You guys were a core part of our team, and therefore you helped shape our product. I couldn't put a specific number value on the impact or anything, but I definitely would say that your expertise brought a lot to the table and that it positively influenced our system architecture.

For example, using [Amazon's SQS](https://aws.amazon.com/sqs/) to communicate with our sender nodes via message queues; we might have went that way otherwise, but I think that was your idea. I didn't have that in mind. So it's possible we could be using that now only because of you.

**Ernesto:** That was a very interesting project. Thanks for the kind words! I appreciate that. I actually have a question about that but I'll leave it for later. You said a little bit about the value we added to the team. **Anything in particular that you valued from working with us?**

**Preston:** We work with a number of contractors, but the thing that set the really good ones apart was how they, instead of just doing the job they were told to do, they would actually figure out what we needed and try to find ways to solve our problems as though they were members of the team. And that's exactly what you guys did. Whereas the bad contractors, they would accept the terms that we gave them, and they would give us what we asked for. It was kind of like we were holding their hand the whole time, and it was not really worth it to hire them at that point.

But you guys were much different. You took the initiative to figure out where there were problems, where updates/maintenance were needed, then went out and did the work. That was very useful.

**Ernesto:** I think one thing that I valued from our engagement is that  there was value in disagreeing with you every now and then. And not just disagreeing for the sake of disagreeing, but proposing other ideas or other ways to implement a solution, then having a discussion about it, and then presenting the arguments and eventually going with one way or the other.

**Preston:** Definitely. And while I can't guarantee that everybody's going to appreciate that like I do, I know I'm not always right. Sometimes I needed to be challenged.

**Ernesto:** So let's talk a little about how things were after we ended our engagement, **how did we impact your day-to-day engineering operations?**

**Preston:** I think it circles back to what I mentioned before, which is that you guys largely helped put in place at least a framework of processes that we were able to build upon later. Kind of sent us in the direction of using some sort of organizational structure to our development as opposed to simply discussing what needed to be done and doing it, which was the previous way we did it. I hesitate to repeat my previous answer, but it's the only one I can think of.

I should mention, your push for [pair programming](http://wiki.c2.com/?PairProgramming) has been very influential on our team. We do a lot of it.

**Ernesto:** I'm glad to hear that. We are big fans of pair programming. **How are guys doing it now? Are you doing it like just when it's needed or do you have scheduled pair programming sessions?**

**Preston:** We generally do as needed, but also if there's a special situation where somebody who has knowledge needs to share with somebody who doesn't. We'll get them to pair up together while working on a feature just to transfer that knowledge. Additionally, now we have office days. Every Wednesday people come into the office. There is usually a lot of programming going on at that time since we're all sitting around together anyway.

**Ernesto:** Cool. So the last question is quite technical and it's about the cluster of server nodes we helped implement and if you could tell me a little bit about the problem we were having before that solution.

**Preston:** There were two problems, actually. One was that we were connecting to [Gmail](https://www.google.com/gmail) from the same IP address for all of our clients and that presented a security risk. If Gmail ever decided to ban us, they could quite easily do so by simply blocking our IP address. Or simply silently routing our messages just to spam or whatever it is they chose to do. So there's the security aspect. And then there was another more simple aspect, which was throughput. We were sending through Gmail and it imposed a limitation on how many messages you could send per minute by simply holding the connection open. So you had to wait around three seconds per message. Accordingly, the throughput was relatively low. We couldn't send for all of our clients in the timeframe that we wanted to.

**Ernesto:** So what value did we add there in terms of the solution, this cluster of sender nodes?

**Preston:** Well, specifically, the problem that you solved that I wouldn't have had a solution for was that of using queues to communicate between the sender nodes and the API server. The one-way communication from the sender nodes to the API, that would seem pretty easy to make an API call. But the other way, it was like are they going to connect to the database, or how exactly is this going to work? And then of course it made a whole lot of sense if you simply use SQS and they have a separate system waiting with the messages all there.

In retrospect, I should have been looking at it going, "Hey, this is obvious." But I didn't have that idea and you guys contributed that.

**Ernesto:** It was really cool to work on that. I think it's one of the coolest projects we worked on in the past three years or so.

**Thanks for your time and your feedback! I really appreciate you taking the time to do this.**

**Preston:** No worries. Hope it helps.
