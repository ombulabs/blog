---
layout: post
title:
date: 2019-07-29 22:28:02
categories:
author:
---

# VIM 101

I would not bore you by telling you the history of vim, and the differences between vi and vim and all of its unix philosophy....
If you are interested in that, you can give it a look [here](https://en.wikipedia.org/wiki/Vim_(text_editor).

So all you need to know is that vim is a text editor... a poweful one.  in my opinion its power comes with how flexible it can be. It can be as simple or complex as you wish. It can serve you to edit a simple config file on a server or you can make it a complete code editing environment if you want.

In this blog post I'll show you the basics of vim and how you can interact with it and yes I'll teach you how to exit ;)

I'll asume you already have vim installed, if you are on a \*nix system you proably already have it.

## VIM modes
Vim is a "modal editor" that means vim will behave different depending on which mode you currently are.

I'll introduce you to three basic modes. **NORMAL**, **INSERT** and **VISUAL**. There are a couple more, but this are the basics ones, and it's all you need to know for now.

### NORMAL - The default's vim mode

This is where you'll spend most of your time and it's the mode where the magic happens. In this mode you can execute commands.

 * INSERT - The mode where you can write stuff
 * VISUAL - The mode in which you can select chunks of text

Open a terminal and type `vim filename`
  * :q
  * :q!
  * :w

## Navigation
 * h,j,k,l
 * ^ or 0 - move to the start of the current line
 * $  - move to the start of the current line
 * gg - jump to the beginning of the file
 * G - jump to the end of the file

## Delete
 * x - delete the character under the cursor
 * dd - delete the current line
 * D or d$ - delete from the cursor to the end of the current line
 * d0 or d^ - delete from the cursor to the start of the current line

## Copy
 * yy - yankk the current line
 * y$ - yank from the cursor to the end of the current line
 * y0 or y^ - yank from the cursor to the start of the current line

## Paste
  p

## Searching
 * f-F
 * t-T
 * /  - Forward
 * ?  - Backward
 * *  - Word under cursor - forward
 * #  - Word under cursor - backward
 * n  - Next result, forward
 * N  - Next result, backward

## Commands = operator + motion
### Motions
  * w - Forward to the beginning of next word
  * b - Backward to the next beginning of a word
  * e - Forward to the next end of word

### Operators
  * c - Change
  * d - Delete
  * y - Yank

## Resources
  * $ vimtutor
  * http://vim-adventures.com/
  * :h :help
  * https://github.com/bronzdoc/dotfiles
  * http://www.slant.co/search?query=vim

