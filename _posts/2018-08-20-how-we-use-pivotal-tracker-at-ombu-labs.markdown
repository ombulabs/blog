---
layout: post
title:  "How we use Pivotal Tracker at Ombu Labs"
date: 2018-08-20 11:10:00
categories: ["agile", "pivotal-tracker"]
author: "etagwerker"
---

We tend to use [GitHub](https://github.com) for everything at [Ombu Labs](https://www.ombulabs.com), but sometimes our clients
prefer [Pivotal Tracker](https://www.pivotaltracker.com). We have no problem
with Pivotal Tracker, we just like to keep everything in one place, that is why
we prefer GitHub for everything.

There are many things that are easier with Pivotal Tracker, as long as you are
using it the right way. Some of its features are very useful for agile teams like
ours. This is how we like to use it to ship value with every sprint and keep
track of our [velocity](http://wiki.c2.com/?ProjectVelocity).

<!--more-->

## Step 1: Filing user stories

Every thing has to be tracked according to the type of story. Most of the user
stories are either *features* or *bugs*, although sometimes there will be *chores* to be
done. If a *chore* reoccurs many times, then it's probably time to write a *feature*
to reduce the time spent completing that *chore*.

## Step 2: Describing user stories

Every [user story](https://www.mountaingoatsoftware.com/agile/user-stories) should
be a simple description of a feature:

```
As a < type of user >, I want < some goal > so that < some business goal >.
```

The description of the user story should be very clear about the expected outcome.
This will explain what is the exit criteria for the story. It is very helpful
for designers and developers to understand what needs to happen for a user to
be happy with the feature.

This is an example from one of our recent projects ([https://audit.fastruby.io/](https://audit.fastruby.io/)):

```
As a user I want to submit my Gemfile.lock
so that I can see an audit analysis of its vulnerabilities.
```

<img src="/blog/assets/images/user-story-audit-fastruby-io.png" alt="Example of a simple user story" class="medium-img">

If the client requested this feature, you should add them as the *Requester* of
the story. If it was you, then you can add yourself to it.

## Step 3: Estimating user stories

Before you start working on a user story, you will need to estimate it. You
can estimate it with 0, 1, 2, 3, 5, or 8 points. We prefer to use a [Fibonacci](https://en.wikipedia.org/wiki/Fibonacci_number)
sequence to estimate stories.

If a story is more complicated than 8 points, you should break it down in two or
more stories. When you estimate, you must remember that you are [estimating
complexity](https://rubygarage.org/blog/3-reasons-to-estimate-with-story-points),
**not hours**. Different developers might take different amount of time
in completing that story, so **we shouldn't estimate hours**.

For the example we mentioned before, we estimate that that story has 3 points of
complexity.

<img src="/blog/assets/images/user-story-estimation-fibonacci.png" alt="State of a simple user story before you estimate it" class="medium-img">

## Step 4: Starting and finishing user stories

You should always pick the first unassigned story from the top of the backlog.
If the first story is assigned to someone, you may check with them if they need
your help with it.

<img src="/blog/assets/images/user-story-start.png" alt="State of a user story after you have estimated it" class="medium-img">

Once you start a story, the clock starts ticking on that story. You should try
to finish it as soon as possible.

When the time comes and you're done working on the code and tests for that story,
you will submit a pull request and attach it to the user story. At that point,
you can click the *Finish* button.

<img src="/blog/assets/images/user-story-deliver.png" alt="State of a user story after you finish it" class="medium-img">

## Step 5: Delivering a user story

When your pull request has been approved by a code reviewer, you or the reviewer
can merge this pull request and deploy it. If the code doesn't get deployed
automatically (**it should!**), you should deploy it to staging so that the
*Requester* can accept or reject the implementation.

Before you click *Deliver* you should perform a quick [smoke test](http://wiki.c2.com/?SmokeTest) to make sure
that your changes were successfully deployed to the staging environment.

After that, you can go ahead and *Deliver* the user story. This will move the
story to an Accept/Reject state:

<img src="/blog/assets/images/user-story-accept-reject.png" alt="State of a user story after you finish it" class="medium-img">

## Step 6: Accepting or rejecting a user story

If the *Requester* approves the story, they will mark it as accepted. No more
work is necessary in this user story. Great!

If they reject the story, they should provide a detailed description about the
rejection. If you were the *Requester* you can ask yourself this question to
describe the problem/s:

- What did you expect and what did actually happen?
- What cases worked and what cases didn't work as expected?
- Was the interface clear enough to understand what was going on?
- Did you test many cases and it failed with an edge case?

<img src="/blog/assets/images/user-story-rejecting-story.png" alt="State of a user story after you deliver it" class="medium-img">

If possible, describe the exact scenario and steps that you took to find a
problem with the user story. If you think that adding a screenshot will help,
you should add it as a comment after you reject the story.

## Step 7: Restarting a rejected user story

There will be times when your implementation is not good enough. It may fall
short in terms of usability, performance, or behavior. The good news is that
our process works. Someone verified a feature you implemented and found issues
with the implementation.

When the time comes, you will find a user story in this state:

<img src="/blog/assets/images/user-story-restart.png" alt="State of a user story after someone rejects it" class="medium-img">

You can simply restart the user story and resume working on it. If you need to
submit another pull request to patch the feature, you can continue with step 4.

## Conclusion

Pivotal Tracker provides a great way to track velocity and they recently launched
an integration with Github which improves traceability from feature to
implementation.

It is not our first choice when it comes to project management tools, but we
can adapt to our client's tools and thrive using it.
