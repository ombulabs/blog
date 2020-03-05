---
layout: post
title: "Submit Great Pull Requests"
date: 2019-04-18 15:00:00
reviewed: 2020-03-05 10:00:00
categories: ["agile", "learning", "pull-requests"]
author: "emily"
---

Pull Requests let developers tell other team members about changes they've made to a project repository. Once a pull request is created, team members can review the set of changes, discuss potential modifications and even push follow-up commits before the changes are merged into the repository. Therefore, it is important to make sure that your pull requests are easily understandable to the reviewers.

<!--more-->

Fellow developers need to be able to understand what the pull request is trying to achieve, what approach is being taken, and how all of the changed files relate to each other. **In short, a great pull request will:**

- Be short, have a clear title and description, and do only one thing
- Be reviewed quickly
- Reduce the probability of introduction a bug into the stable branch
- Facilitate the on-boarding of new developers
- Not block other developers
- Speed up the code review process and consequently, product development
- Target the right branch, usually either master or develop, depending on the project

In order to make a **great pull request**, follow these [Ombu Labs](https://www.ombulabs.com) approved tips:

### 1. Make smaller pull requests

This is the best way to speed up your review time. **The smaller the pull request, the easier it is for the reviewers to understand** it and provide feedback.

### 2. Break down large pull requests into smaller ones

[A study](https://opensource.com/article/18/6/anatomy-perfect-pull-request) demonstrated that **a good pull request should not have more than 250 lines of changed code**. If the functionality you are working on is too big or complex, it could be helpful to split it into smaller and more manageable pull requests.

Breaking down large pull requests keeps you in accordance with the **Single Responsibility Pattern**. The SRP is a computer programming principle that states that every module or class should have responsibility for a single part of the functionality provided by the software, and that responsibility should be entirely encapsulated by the class.

Following the SRP reduces the overhead caused by revising code that attempts to solve several problems. Before submitting a pull request for review, try applying the single responsibility principle. If the code does more than one thing, break it into other pull requests.

### 3. The title of the pull request should be self-explanatory

Similarly, a useful summary title makes it clear to the reviewer what’s being solved at a high level, which removes an extra step for the reviewer. The title should make clear what is being changed.

Here are some examples:

- "Add test case for getEventTarget"
- "Improve cryptic error message when creating a component starting with a lowercase letter"

### 4. Write useful descriptions

The most helpful descriptions guide reviewers through the code as much as possible, highlighting related files and grouping them into concepts or problems that are being solved. Inside the pull request description try to:

- Describe what was changed in the pull request.
- If there was some research done for the pull request, make sure to mention that and link to relevant sources.
- Explain why this pull request exists or add a link to the story that is being addressed.
- Make it clear how the code does what it's supposed to do— for example, does it change a column in the database? How is this done? What happens to the old data?
- Use screenshots to demonstrate what has changed. This is especially important for CSS, HTML and JS changes.
- If the PR is not ready for review, make it clear by adding WIP (Work in Progress) in the title or description.
- Add comments to specific parts of the code (in Github/Bitbucket) if you think that it could help the reviewer to understand it.

These suggestions can save reviewer a lot of time. Take a look at [this sample PR](https://github.com/rails/rails/pull/32865) to see what a good description looks like.

### 5. Review and Submit

Before finishing the submission of your pull request, make sure that you review it yourself. Check that the explanation is good enough and take a look at all the changed files to see if something is wrong or missing. Then go ahead and submit!

Here is the workflow that we like to follow:

1. Submit a PR (the title and description should describe the changes or point to a page with more info).
2. The build should pass. If it doesn't, work on it until it does.
3. When the build passes, the reviewer will assign themselves the PR before they start reviewing it.
4. The reviewer will review it giving useful feedback and asking questions. If the PR needs work, the reviewer will add the needs-more-work label.
5. Address the questions and update your PR.
6. When all issues have been addressed or solved, remove the needs-more-work label and ping the reviewer with @reviewer
7. If there are more issues, the reviewer will go to step #4. If not, the reviewer will merge the PR and delete your branch! 
