---
layout: post
title: "4 Useful Github tricks which should be more popular"
date: 2015-01-19 18:35:00
categories: ["git", "github"]
author: "mauro-oto"
---

If you are using git in 2015, you are probably also using [Github](http://www.github.com), unless you're self-hosting or still betting on [Bitbucket](http://www.bitbucket.com).

Below are some cool, useful tricks you can use on Github which can probably make your life easier:

## T

This is probably the most-well known and most used. By hitting the T key while browsing a repository, the file finder comes up, which lets you type in any file and it will search for that filename in the repository.

You can also navigate using the arrow keys, and access the file by hitting Enter.

## .diff / .patch

By appending .diff to any diff URL on Github, you'll be able to see the plain-text version of it, as if looking at output from git.

## ?w=1

A not-so-well-known tip is appending ?w=1 to a diff URL to omit whitespaces from a diff.

[Example diff on ombulabs/setup](https://github.com/ombulabs/setup/commit/7c824aaca37a401bdd6d0f8acd1b11f510648bb4) vs [Example diff on ombulabs/setup with w=1](https://github.com/ombulabs/setup/commit/7c824aaca37a401bdd6d0f8acd1b11f510648bb4?w=1)

Probably not the best example but useful to remember for longer diffs.

## .keys

You can get anyone's public keys by appending .keys to their Github username. For instance, to get my public keys: [mauro-oto](https://github.com/mauro-oto.keys)

For great git-specific tips, try [here](http://mislav.uniqpath.com/2010/07/git-tips/) or [here](http://gitready.com/).
