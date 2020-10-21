---
layout: post
title: "Introducing Points - An blind estimation tool from OmbuLabs"
date: 2020-10-16 12:00:00
categories: ["open-source", "agile"]
author: "fionadl"
---

At OmbuLabs our goal is always to smooth processes, and make work easier. Isn’t that what software engineering is really all about in the first place?

When we are getting ready to do a project or to make a proposal one of the questions that we are always asked by clients is “how long will it take”? To come up with an estimate on timing we like to use a system of [points](https://www.ombulabs.com/blog/agile/scrum/become-better-estimators.html) and blind estimates by multiple team members to find an average of how complex the project will be. We can then use this information, together with our database of delivered projects, to estimate how long the project will take.

To accomplish this, and make the process smoother we built a tool called Points and now we have [moved it to open source](https://www.ombulabs.com/blog/open-source/open-sourcing-a-private-project.html) in case it can be of use to any other teams out there!

<!--more-->


## How Points Works for Team Members
Currently you can sign into Points using Github. Once signed in you are on the Projects Page and can either click on a previous project, or create a new one.

<img src="/blog/assets/images/points/project-page.png" alt="project points ombulabs" class="medium-img">

Once a project is created you can go in and add stories to the projects. Each story can then have an estimate of best case scenario and worst case scenario added. Each team member who adds estimates will not be able to see those of other team members. Blind estimation is super important to get a good sense of how long the team thinks the project will take.

<img src="/blog/assets/images/points/estimate-page.png" alt="estimate points ombulabs" class="medium-img">

Another helpful feature we have included on each project page is a `Generate Action Plan` button, which will take you to a page with all of the stories formatted for copying and pasting into another document. This is extremely useful for client proposals.

## How Points Works for Admins
An admin can sign into Points in the same way as a team member, but they will also have the extra option of a `View Reports` button.

On the View Report page the admin will be able to see all of the team members estimates, as well as averages of the estimated amount of points it will take to complete the stories and the project.

<img src="/blog/assets/images/points/admin-page.png" alt="admin points ombulabs" class="medium-img">

If there are any huge discrepancies the admin can jump on a call with the team members who performed the estimates and find out why they had such different views. From there, things can be adjusted. With all of this information in hand the admin will be able to create a proposal for the client that will be quite precise.

In the Report page the Admin also has a Download Average Estimate Report button, that allows them to download the stories with the respective best and worst case scenario averages in CSV format. This is very helpful as the information can be fed into the tool that'll generate the time estimates (be it Excel or a specific statistical analysis tool).

## After the Project
Let’s say all goes well, and the client approves the proposal and the project moves forward! This will be a chance to gather real data on how long and how complex stories really were. This is why we have also created a section in the admin panel for entering actual points.

<img src="/blog/assets/images/points/real-score-page.png" alt="real score points ombulabs" class="medium-img">

Later we can use the actual point data to become better estimators on future projects. You can [find more information on that process here](https://www.ombulabs.com/blog/agile/scrum/become-better-estimators.html).

## Conclusion
Points is a blind estimation app that allows our team to create project proposals that are more spot on. Points is open source and an ongoing project. We welcome contributions, and hope that our project can be useful to you!
