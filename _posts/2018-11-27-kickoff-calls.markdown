---
layout: post
title:  "Kickoff Calls for New Projects"
date: 2018-11-27 11:00:00
reviewed: 2020-03-05 10:00:00
categories: ["agile", "continuous-learning"]
author: "emily"
---

When starting a new software development project with a client, it is important to get started on the right foot. The way you communicate with a client at the beginning of a project can set the tone for how communication will be throughout the project.


Therefore, at [Ombu Labs](https://www.ombulabs.com), we believe it is crucial to start off every new project with a *Kickoff Call*, where we can take time to get to know the client's team and speak in depth about their goals and priorities for the project. We like to discuss the following list of topics with clients during our calls:

<!--more-->

#### Overview

During the Kickoff Call, we like to start off by introducing ourselves and getting to know the client and their team. It can be helpful to give an overview of the project and make sure all team members are familiar with the goals of the project. **_What does the client want to build? Who will be using this app? Is this an existing project or a new idea?_**

#### Project Management

We want to understand what the client wants to do in terms of project management. **_Do they use an existing service to manage stories? If so, what do they use? Do they want us to join an existing project board?_**

At [Ombu Labs](https://www.ombulabs.com) we like to use [GitHub](https://github.com) for code management (pull requests) and [Pivotal Tracker](https://www.ombulabs.com/blog/agile/pivotal-tracker/how-we-use-pivotal-tracker-at-ombu-labs.html) for project management (user stories).

#### Access

It is important to make sure that all team members have access to any code and project management services that are going to be used. **_Does everybody on the team have access to the project repositories? Does everyone have access to the project management service?_**

#### Project Setup

Once the team has access to the code, developers should try to get started setting up the project on their own. Ideally this will take place before a Kickoff Call, however, if there is an issue, we should mention that during the call. **_Are the instructions in the README clear enough? Do they work?_**

#### Communication

**Chat**: We want to invite the client to our [Slack](https://slack.com) (we prefer this) or join their own internal communication tool. That way we can move our conversation from email into a more dynamic environment. There will be plenty of questions and we should have a direct line to a tech leader in our client's company.

**Calls**: In terms of calls, we like to have one or two calls per week: at the beginning and end of the week. That way we can share what we are planning to work on during the week, what we have accomplished, and what blockers we may have. During the call at the end of the week, we can demo the work that has been done for the client. **_Work with the client and team members to find a time that works for everyone._**

Sometimes clients will want us to participate in their daily calls, we can do this as well. We should find out what level of communication they're comfortable with.

#### Quality Assurance / Code Review

In every project, we will do internal quality assurance and code reviews, but we should encourage our clients to do their own quality assurance and code reviews as well. **_If we need to get someone to review our pull requests, who should we reach out to when we want to merge something to master? What is the client's code review process?_**

#### Git Branches

**_What kind of Git branching model does the client follow? Do they have master, develop, and feature + fixes branches? Or do they have only one master branch and feature + fixes branches?_**

In our [Rails Upgrade](https://fastruby.io) projects for example, we encourage our clients to merge our changes to master as soon as possible and get them to staging as soon as possible. That way we can know right away if the code works or if there are some issues.

#### Error Handling

If we are joining an existing, productive project, we need to make sure that the client is using an error tracking solution (e.g. [Rollbar](https://rollbar.com), [Sentry](https://sentry.io/welcome/), or [Airbrake](https://airbrake.io)).

**_If so, what are they using? Could we get access to their resources?_** This will help us a lot in responding immediately to bugs we may introduce during the project.

#### Deployment Strategy

Our preferred deployment strategy is to deploy `develop` to `staging` and `master` to `production`. **_What is the client's strategy?_**

**_How often does the client deploy? When are good days/times to deploy changes?_** We usually try to avoid deploying on Fridays, because we don't want to introduce any bugs over the weekend.
