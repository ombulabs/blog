---
layout: post
title: Using Actual Story Points to Become Better Estimators
date: 2020-03-10 14:30:00
categories: [agile, scrum]
author: abizzinotto

---

At OmbuLabs, we strongly believe in continuous improvement. 

As a Scrum team, before starting a sprint we estimate the complexity of the stories using the [Fibonacci scale](http://www.velocitycounts.com/2013/05/why-do-high-performing-scrum-teams-tend-to-use-story-point-estimation/). But how do we become better at estimating stories? How do we know we're evolving as a team?

In this article I outline the process we are following to become better estimators.

<!--More-->

# The Projects

At OmbuLabs we work on a number of different, challenging projects. We do, however, also work on very similar projects, namely, [Rails upgrade projects](https://fastruby.io). Therefore, we identified the critical path we need to follow on every Rails upgrade from version A to version B and used it to create a template we can follow whenever we work on a project of this nature.

# The Blind Estimation

Once we have a project in our hands, we turn the steps in our Rails upgrade template into stories. Since we are a remote team, we developed an internal tool to facilitate the blind estimation process. Once the stories are created, two developers add their estimates for each story. 

To preserve the blind nature of the estimation, the developer estimating can only see the page to input their estimates. They cannot access anyone else's estimates.

Once both developers have inputted their estimates, the Scrum master can go in and generate a report detailing the estimates from each developer and the average estimate for each story.

# Handling Discrepancy

There will always be some discrepancy between estimates. After all, there were two different people estimating. However, sometimes the discrepancy is too big. How do we handle that?

As a remote team, the estimation process isn't as straight forward as [planning poker](https://www.agilealliance.org/glossary/poker/) done in a meeting. So once the Scrum master reviews the estimates, if there are any stories with estimates that are too far apart, we have a "reconciliation call". 

The main purpose of the reconciliation call is to understand what caused the discrepancy. The developers get a chance to explain why they believe a story is so simple or so complex and have a discussion about it to explore what's under the "tip of the iceberg". Maybe it's a giant iceberg and someone was only looking at the tip. Maybe there is no iceberg but someone thought there would be.

The purpose of this call is to reach closer estimates. There is no need to agree on a particular estimate though. The goal is to reduce the discrepancy, not eliminate it completely.


# Looking Back

The three previous steps are done before we start working on the Rails upgrade project and before we start a sprint. But, during the sprint, we might realize an estimate was too optimistic or too conservative. So we created a way to use that to become better estimators.

During our retrospectives, we now take some time to evaluate the stories worked on and look back at the original estimates. Were they fair? Optimistic? Conservative? What was the real complexity of that story?

To organize that process, we added a feature to our internal tool that allows the Scrum master to enter Actual Story Points for each story. Once all stories have been reviewed and actual complexity has been established, we calculate the offset.

That measure of how far off we were will help guide us on the next project, as well as tell us, overtime, how we're progressing to become better estimators.

# The Possibilities

This feature also opens up some possibilities for the future.

We now have a database of actual story points telling us what the complexity of each story for each Rails upgrade project we work on is. A future possibility is to use that data to suggest estimates when working on similar projects. This way, we save time while still giving the developer room to evaluate actual complexity based on project particularities.

For more information about upgrading your Rails application, check out our ["Upgrade Rails Series"](https://www.fastruby.io/blog/tags/upgrades), a series of do-it-yourself guides to upgrading Rails.
