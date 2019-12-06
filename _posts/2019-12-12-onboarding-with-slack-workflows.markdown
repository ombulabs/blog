---
layout: post
title: "Onboarding New Team Members with Slack Workflows"
date: 2019-12-12 10:30:00
categories: ["scrum", "Slack"]
author: "abizzinotto"
---

When a new team member comes onboard, there are several tools and resources they need to access, as well as processes, practices and guidelines they need to be aware of. There is also workflow and company culture information you want to communicate. After all, each company has its unique features and you want new team members to be comfortable with the existing team.

For remote teams, this process can be very challenging. Thankfully, if you use Slack, you can use their Workflows feature to easily onboard new team members, making the process actionable and easy to follow. 

In this article I'll describe how I used [Slack Workflows](https://slack.com/intl/en-br/help/articles/360035692513-Guide-to-Workflow-Builder) to make the onboarding process here at [OmbuLabs](https://www.ombulabs.com) quick and easy.

<!--more-->

## The Onboarding Process

Our onboarding process includes a few steps that must be completed before a new developer is up and running.

First of all, we have specific tools they must have access to before being able to do anything else. Additionally, we also have some key articles in our internal wiki that are must reads, as they contain helpful information about guidelines, policies, company culture, etc. Finally, we have specific channels, repositories and projects they need to access to be familiar with our projects and open source contributions.

## Using Slack Workflows to Onboard New Team Members

Recently, [Slack](https://www.slack.com) released their [Workflows](https://slack.com/intl/en-br/help/articles/360035692513-Guide-to-Workflow-Builder) feature. This allows a user to create workflows with different triggers, including a trigger when a new member joins a channel. 

We have an #onboarding channel in Slack to help new team members get situated. I created a workflow that is triggered when a new member joins that channel and is, essentially, a sequence of messages with instructions and/or information and a button that takes the new team member to the next step.

The workflow would then look like this:

_**Message 1:**
Hello! Welcome to our team!
First, let's make sure you have access to all these Slack channels:_

_#channel1
#channel2
…
#channeln_

_If you don't have access to any of those channels, please contact @someone._ 

_**Button 1:**
I'm good! Let's move on!_

_**Message 2:**
Great! Now here's a helpful article with information on how to use each channel to communicate:_

_[link]_

_Let me know when you finish reading it :)_

_**Button 2:**
I'm done! What's next?_

…

_**Message n:**
Perfect! You're all set! Welcome to the team!_

## Why create an onboarding workflow?

It can be easy to forget to give a new team member access to a specific tool or to provide them with helpful information about the company culture or even to make sure they are aware of all policies and procedures they need to know. Specially on smaller teams and remote teams.

With the Slack workflow, the new team member is taken step-by-step through a pre-set, reviewed process that contains everything they need. It speeds up the process, as they don't need to wait on someone to point them in the right direction every time a step is completed. As they move through the process, new messages are triggered. And if they are missing access to any Slack channel or have questions about anything, they have a quick link in the message itself to the person they need to contact.

It's easy to maintain and easy to follow!

## Other ways to use workflows

1. **Onboard developers into new projects**

As a software agency, we work on several different client projects. Each project has a different set of tools, documents and repositories developers need to access. Each project also has its own internal Slack channel.

Therefore, we also use workflows to onboard developers into a new project. When they join the channel, the workflow triggers and takes them through the steps to get access to the tools they need and locate any documentation they need to read.

2. **Make it easier to identify and remove blockers**

As a remote team, we are not always online at the same time. During our daily standup calls for a project, we let others know of any blockers we may have. But as we move through the day, new blockers might appear.

That's why we have a workflow in the #scrum channel that is triggered through the action menu. Whenever a developer is blocked, they can go to the #scrum channel and click the action button to trigger the workflow. It opens a form they complete explaining what project they're blocked on and what's the blocker. Once they submit the form, the Scrum Master is alerted and can remove the blocker and let the developer know.

With a dedicated channel to receive these notifications, it's easier to keep track of who needs what, preventing messages from getting lost in the middle of other conversations happening in the channel.

3. **Workspace Guidelines**

In addition to our team members, our Slack workspace is also shared with sub-contractors. We can use workflows to trigger a message whenever someone new joins the #general channel. 

This message contains general rules and workspace guidelines, as well as information on resources available and who to contact in case of questions. 

At the bottom of the message, there is a button to click to confirm they've read and understood the guidelines. Once that button is clicked, a notification is sent to the workspace administrators.

## Conclusion

Slack workflows can be very helpful when onboarding new team members into a remote team. They're easy to setup and edit, so making updates doesn't require a lot of effort. They can also be used in a variety of other situations to make your team and daily processes more efficient. 
