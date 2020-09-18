---
layout: post
title: "How to open source a private project"
date: 2020-09-17 11:00:00
categories: ["open source"]
author: "fionaDL"
---

Open Source is one of the things that we value as a company. Our philosophy is that “everything we do should be open by default”. This is why in the past few months we decided to open source two of our internal projects. We built [Dash](https://github.com/fastruby/dash) and [Points](https://github.com/fastruby/points) to make our daily processes smoother, and then we thought “hey, why not share them with everyone?”.
Now we also want to share the process of how we turned them from private to open source.

<!--more-->

## Making a list

Before we began the process of open sourcing we decided to make a list. We thought about what it would take to move the projects into the eyes of the public. We thought about what we wanted the app to look like, if there were any “secrets” in the code, and how we would present the projects. These are some of the things we came up with for our checklist.

### Hiding sensitive information

It is important to go through commit history and the code to make sure there are no “secrets” you would be sharing with the public when you open source. We ended up needing to squash the commit history because we had some areas that had sensitive information. Maybe your code is already free of sensitive information, but it is a good idea to check.

Look at places where you may have hardcoded company specific or personal information. We often move these hardcoded pieces of code into environment variables. Just make sure you include the environment variables and an explanation in the README.

### Creating a comprehensive README

Having a good README is fundamental when creating an open source project. It is important for it to be robust and filled with easy to understand information on setting up and using the project. Some things that are important to include:

- Description of the Project
- Steps on how to setup the project
- A contribution guide
- Code of Conduct
- Sponsorship (if applicable)
- License

You can read more about this over [here](https://www.fastruby.io/blog/open-source/ombulabs-open-source-guidelines.html) in our article about open source practices.

### Moving the project to Open Source:

The next step in open sourcing the project is to move it from Private to Public. We use [GitHub](https://github.com/) to store our repositories, so these steps are the ones for GitHub.
To completely delete the history including Pull Requests it is necessary to create a fresh repository. If you didn’t have any sensitive information to hide, and there is no problem with sharing the commit history, you can simply go to settings on the repository page, enter the danger zone at the bottom of settings and click on `Change repository visibility`.

If you do need to hide the history of the project there are several ways to do this, but this is the way we used:

Note: before beginning this we made a copy on GitHub and locally in case anything went wrong.
```
$ git pull origin <main branch for repository >
```
Follow steps on [GitHub](https://docs.github.com/en/enterprise/2.17/user/github/administering-a-repository/deleting-a-repository) to delete the repository.

Follow steps on [GitHub](https://docs.github.com/en/github/getting-started-with-github/create-a-repo) to create a new repository and make sure to choose the public option when choosing the visibility, and don’t include the README.
```
# Choose which commit you would like to include in the new tree(we chose the first commit). Use git log and copy the commit hash.
$ git reset --soft <commit hash>
$ git commit --amend
# adjust commit title as needed
$ git remote rename origin <oldrepo>
$ git remote add origin <clone new GitHub repository>
$ git push origin <main branch>
```
If you are looking to squash the last number of commits into a single one in the commit history, we can use the git reset --soft [commit] option. In our case we squashed all commits against the first one, but deleting the repo and recreating it would have given the same effect. There's an interesting side effect in this approach though, GitHub seems to detect contributions from other developers while if it was a repo from scratch it wouldn't.

### Creating a GitHub Page
A GitHub page is not essential when open sourcing a project, but it is a good idea. We have GitHub Pages for several of our projects including; [Dash](https://fastruby.github.io/dash/), [Points](https://fastruby.github.io/points/), and [Pecas](https://fastruby.github.io/pecas/).

Steps we used to create a GitHub Page
```
$ git checkout --orphan gh-pages
# preview files to be deleted
$ git rm -rf --dry-run .
# actually delete the files
$ git rm -rf .
# create an index.html file
# add any styling you want to associate for the file
# Push gh-pages branch to GitHub
```
Go into settings for the repository and activate a Gh-Page. It will automatically use your gh-pages branch.

Note. This is for custom GitHub pages. It is also possible to quickly build a GitHub page using a theme and the already existing README.

### Badges
Adding Badges to the README is a great way to show pieces of information to potential users quickly and aesthetically. [Circle CI](https://circleci.com/docs/2.0/status-badges/), [Travis CI](https://docs.travis-ci.com/user/status-images/), [Code Climate](https://codeclimate.com/github/codeclimate/codeclimate/badges/) and more have badges or status images that you can embed in the README.

### Adding known issues to GitHub

We tend to use [Pivotal Tracker](https://www.pivotaltracker.com/) for our internal projects to keep track of stories and known issues. Once we open source we like to close the Pivotal Tracker project and move all known issues or desired features to GitHub Issues. This way it will be a public history of everything being worked on in the project.

### Announcing your new open source project
At OmbuLabs we like to announce our projects with a blog post. We will also use Tweets, posts on LinkedIn or share anywhere else we feel is appropriate.
We hope you found our process helpful, let us know if you have open sourced a project recently and have any tips to add!
