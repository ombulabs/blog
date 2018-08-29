---
layout: post
title:  "FastRuby.io: Exit Calls"
date: 2018-08-22 11:10:00
categories: ["continuous-learning"]
author: "etagwerker"
---

At Ombu Labs we believe that if you are not learning from your mistakes you are
doing it wrong. It is simple: The only unforgivable mistake is to not learn
from our mistakes.

That is why we try to incorporate feedback into everything we do. We
embrace code reviews and [pair programming](https://www.ombulabs.com/blog/agile/pair-programming/joys-and-woes-of-pair-programming.html) as a way to get constant feedback on a
daily basis.

Another step that we incorporate into every client relationship is an exit
call. This call gives us an opportunity to assess how well we performed.

If we performed well: Great! What can we do more of? If we performed poorly: That
is terrible! But it is also an opportunity to learn. What can we do to make it
better for our next project?

<!--more-->

Here are some of the questions that we like to ask:

- How was it doing business with us?

- Is there anything we could have done differently?

- What did you like about our service?

- What did you hate about our service?

- What did you think about our Rails upgrade process, is there anything we can do to improve it?

- Did the team communicate effectively? Was our communication with you and your team effective?

- What did you like best about our service?

- Did we meet your expectations?

- Was there anything you didn't particularly like?
  - How would you have done things differently?

- Would you work with us again? (In a scale from 1 to 10)

For the right project 10.

- What did you like about our Rails upgrade?

- During the project, would you have done anything differently?

- Do you have a quote for us? That we could use in fastruby.io

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
