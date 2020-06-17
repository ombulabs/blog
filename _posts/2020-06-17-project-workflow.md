---
layout: post
title: "The OmbuLabs Workflow: working with GitHub and Pivotal Tracker"
date: 2020-06-17 11:00:00
reviewed: 2020-06-17 11:00:00
categories: ["agile", "pivotal-tracker", "github"]
author: "abizzinotto"
---

As a remote team, we work and communicate asynchronously a lot of the time. Additionally, as a software agency, we work not only on client projects but also internal projects related to various aspects of the company. This means we will have stories and pull requests opened accross different internal projects at all times and it is important that everyone is on the same page when it comes to what needs their attention and what the next steps are.

We have shared [more information on how we use Pivotal Tracker here](https://www.ombulabs.com/blog/tags/pivotal-tracker). We also like to use [GitHub](https://github.com/) to its full potential. Therefore, we needed a standardized workflow that would take into account how we use both these tools and ensure everybody on the team knows what is going on by looking at a [Pivotal Tracker](https://www.pivotaltracker.com/) board or a list of open Pull Requests.

In this article, I will walk you through the workflow we created for our team. You can [find a flowchart representation of the workflow here](https://www.ombulabs.com/blog/assets/images/project-workflow/github-pivotal-flow.png).

<!--more-->

## Step 1: Starting a story

When a developer is ready to start working on a story, they find it in the appropriate project in [Pivotal Tracker](https://www.pivotaltracker.com) and click the Start button. This means they are actively working on implementing that feature, fixing that bug or handling that chore.

## Step 2: Open a Pull Request

When the developer has finished working on the story and is satisfied with the implementation, they open a pull request. To ensure the best person to review the pull request is tagged for review, we use the [GitHub Code Owners](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners#codeowners-file-location) feature. However, the developer can tag more people for review at their discretion.

By default, a pull request only needs approval by **one** reviewer to be considered ready for Manual Testing. If the author decides more than one person should review the pull request, they must add a note to it stating this and explaining the reason.

After opening the Pull Request, the author must grab the link and use the Pivotal Tracker integration to GitHub to link it to the appropriate story. At that point, they should also click the Finish button on the story to indicate it is finished and is now awaiting code review.

## Step 3: Reviewing a Pull Request

After the pull request is opened, the reviewer(s) has 24 hours to complete the code review. There are three possible outcomes:

**Approve:**
The Pull Request is approved and can move forward to manual testing.

If the reviewer approves the pull request and leaves comments, it is up to the author to address them or not. But the pull request will continue to move along in the process regardless.

**Comment:**
The Pull Request is not approved but the author can address or disregard the comments. If they choose to disregard the comments, there must be a reply to the comment explaining why.

However, in order for the Pull Request to be considered code reviewed and ready to Manual Testing, there must be an approval, either by the original reviewer or a second one.

**Request Changes:**
The Pull Request is not approved and the author **must** address the comments.

Once the requested changes have been addressed, the reviewer who requested them must review the pull request again and either approve it or request further changes.

In this scenario, even if a different reviewer approves the pull request, it cannot move along in the process until it is approved by the reviewer who requested changes.

Additionally, if the Pull Request was approved by a reviewer and a second one reviews it and requests changes, the Pull Request is not considered code reviewed until those changes are addressed.

## Step 4: Approving a Pull Request and Deploying to Staging

Once the Pull Request has been approved, the reviewer must deploy the relevant branch to our staging environment and add the Ready for QA label to the Pull Request, indicating it is ready for manual testing. This tells the author and the tester the pull request passed Code Review.

The reviewer and the author must also ensure the Pivotal Tracker story reflects that the pull request passed code review by clicking the Deliver button in the story, putting it in an Accept / Reject state.

## Step 5: Accepting and Rejecting stories

After the approval of a Pull Request, it is ready to be manually tested. This is done by the Product Owner, who will make sure the implementation actually satisfies the requirements set in the story and there are no issues associated with it.

**Accepting a Story**
If the story passes manual testing, the Product Owner, removes the Ready for QA label and adds the Ready to Merge label. This means the Pull Request can be merged by the author.

The Product Owner can then accept the story in Pivotal Tracker, indicating it has been successfully implemented.

**Rejecting a Story**
If the Product Owner encounters issue with the implementation of the story during manual testing, they must note these issues in the Pull Request in the form of a comment, remove the Ready for QA label and apply the Needs Revision label.

They must also reject the story in Pivotal Tracker. This will put it in a Restart state and the developer must follow the process again when restarting the story and addressing the issues encountered.

## What if there are issues after deploying to production?

We should not be shipping bugs to production. If after a Pull Request has been merged and the story has been accepted and deployed to production an issue is found, the story **should not be changed to rejected**.

At that point, a **new** user story should be created with the type set to **bug** and the issue found should be described. The team will then proceed to follow the process to fix the bug.

## Pair Programming

We like to use [Pair Programming](https://www.ombulabs.com/blog/learning/pair-programming/how-to-pair-sucessfully.html) whenever it makes sense as a technique. If two developers work on an issue and open a Pull Request while pair programming, it is considered code reviewed and Ready for QA. Therefore, it should be labeled as such and a comment should be added to the Pull Request explaining it was opened during a pair programming session.

## Conclusion

Having the right tools is important and making sure they work well together is a very important part of the process. At OmbuLabs, we value clear and concise communication and the openness of information. Having a standard workflow that allows everyone in the team to be on the same page and have a clear view of the status of any project makes our work easier and more organized.

It is, however, important to keep in mind that every project is different and different issues will have different requirements and particularities. This workflow serves as a guide and a way to standardize our process. It does not override a team members' best judgement and experience. Therefore, in exceptional circumstances, if there is a need to do things differently, we should leave a comment explaining the reasoning behind the decision and follow the steps that are most appropriate under those circumstances.
