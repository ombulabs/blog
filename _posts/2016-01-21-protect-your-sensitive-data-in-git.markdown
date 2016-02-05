---
layout: post
title: "Protect your sensitive data in Git"
date: 2016-01-21 10:36:00
categories: ["open-source", "security"]
author: "schmierkov"
---

If you are working with open source or if you are going to open source a repository, you should ensure that none of your sensitive data (API Keys, Credentials, Passwords) can be accessed by anyone.

**One thing that a lot of people forget, is that this information stay forever in your repository history, if you do not rewrite the history of your repository.**

For instance, what usually happens is that you commit a file with sensitive information. In this Example I added accidentally my `ssh-key` to the repo:

```bash
$ git commit -am 'init git repo'
[master (root-commit) 917a1e1] init git repo
 2 files changed, 52 insertions(+)
 create mode 100644 id_rsa
 create mode 100644 id_rsa.pub
```

After doing a couple of additions, working and editing, I realise that I should never have commited the `ssh-key`. \*facepalm\*

Alright, then I just do a simple `git rm --cached id_rsa` and everything is back to normal. I also add this file to a .gitignore, so that this cannot happen in the future anymore.

```bash
(master) $ git rm --cached id_rsa
rm 'id_rsa'
(master) $ git status
A  .gitignore
D  id_rsa
(master) $ git commit -am 'remove id_rsa'
[master c69deb9] remove id_rsa
 2 files changed, 1 insertion(+), 51 deletions(-)
 create mode 100644 .gitignore
 delete mode 100644 id_rsa
```

So if we now have a look in our commit list, we can still see our first commit where I added my ssh-key. If I checkout this commit, I still have the contents of my `ssh-key` available.

```bash
(master) $ git log
917a1e1 - init git repo (24 minutes ago) <Sirko Sittig>
(master) $ git checkout 917a1e1
((detached from 917a1e1)) $ cat id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIJKQIBAAKCAgEAoequrqsM42na3OpvBFYOpqvzJumr3/kxJTuluXbPyJzVjMXf
d/uhFUJgSqq4AJGOFLLPpQ+9jwfA+WraIxZ9R7p8LgpNdUwKsmGnUvofeD/9Rs1y
YZO8EAjl1URLJ379nN+L5KKPS/48Q4iGp57iwuGzrXLHccLyW5+Z0iMuHlKBQzPx
...
```

To ensure that ALL of this data gets properly removed, I need to remove this file from all the commits in the repository with [git filter-branch](https://git-scm.com/docs/git-filter-branch). The command `git rm --cached` [git rm docs](https://git-scm.com/docs/git-rm) is not sufficient in this case.

```bash
(master) $ git filter-branch --tree-filter 'rm -f id_rsa' HEAD
Rewrite c69deb9779a30e6335ab1a8ac1a0825cfc9302e4 (6/6)
Ref 'refs/heads/master' was rewritten
```

So far so good, but what about my other branches that have been created?
```bash
(master) $ git checkout new-feature
(new-feature) $ ls
drwxrwxr-x  3 sirko sirko  4096 Dec 31 13:20 ./
drwx------ 56 sirko sirko 12288 Dec 31 12:37 ../
drwxrwxr-x  8 sirko sirko  4096 Dec 31 13:20 .git/
-rw-rw-r--  1 sirko sirko  3243 Dec 31 13:20 id_rsa
-rw-r--r--  1 sirko sirko   748 Dec 31 12:41 id_rsa.pub
-rw-rw-r--  1 sirko sirko    64 Dec 31 13:20 my_document.txt
```

Apparently `git filter-branch` is applying this changes only to the current branch, which is actually not what I want. To make this work, it seems that I have to run `git filter-branch` in every existing branch, which makes it pretty annoying. After reading more in the (git docs)[https://git-scm.com/docs/git-filter-branch], I found that I need to apply the `--all` option.

```bash
(master) $ git filter-branch --tree-filter 'rm -f id_rsa' HEAD --all
Rewrite c69deb9779a30e6335ab1a8ac1a0825cfc9302e4 (7/7)
Ref 'refs/heads/master' was rewritten
WARNING: Ref 'refs/heads/master' is unchanged
Ref 'refs/remotes/origin/master' was rewritten
WARNING: Ref 'refs/remotes/origin/master' is unchanged
Ref 'refs/remotes/origin/new-feature' was rewritten
(master) $ git checkout new-feature
(new-feature) $ ll
total 44
drwxrwxr-x  3 sirko sirko  4096 Dec 31 13:41 ./
drwx------ 57 sirko sirko 12288 Dec 31 13:41 ../
drwxrwxr-x  8 sirko sirko  4096 Dec 31 13:41 .git/
-rw-rw-r--  1 sirko sirko   748 Dec 31 13:41 id_rsa.pub
-rw-rw-r--  1 sirko sirko    64 Dec 31 13:41 my_document.txt
```

That seems to be exactly what I want and in the end I just need to `git push --all --force` my changes. **After doing this, all collaborators should dump their local versions and clone a fresh version from the origin.**

Another alternative to working with `git filter-branch` is [BFG](https://rtyley.github.io/bfg-repo-cleaner/) which has some more nifty features.

This tool provides some commands to completely remove big files as well as passwords from your Git history. Sadly I could not get it properly working, big files are still persistent as a git object and passwords can not be deleted because they are `protected by 'HEAD'`. I could not really find a solution for these problems. Maybe you are more lucky!

The easiest and much simpler solution is to initialize a new git repository, after making sure to have all sensitive information removed. The downside is obviously the loss of the project's Git history.
