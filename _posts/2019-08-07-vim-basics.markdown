---
layout: post
title: Vim Guide for Beginners
date: 2019-08-07 10:28:02
categories: ["learning", "vim"]
author: bronzdoc
---

# VIM basics

I will not bore you by telling you the history of [Vim](https://github.com/vim/vim), and the differences between vi and Vim and all of its philosophy...

If you are interested in that, you can give it a look [here](https://en.wikipedia.org/wiki/Vim_(text_editor)).

<!--more-->

So all you need to know is that vim is a text editor. In my opinion one of vim's strengths comes with how flexible it can be. It can be as simple or complex as you wish. It can be used to edit a simple config file on a server or you can make it a complete code editing environment.

Vim is different than any text editor you've probably used. The main idea of vim is that using the mouse in an editor is slow.
You'll move around a text file using one-key shortcuts so you technically wouldn't move your hands out of the keyboard.

In this blog post I'll show you the basics of vim and provide you with the smallest amount of knowledge necessary to make vim useful for yourself, and yes I'll teach you how to exit ;)

I'll assume you already have vim installed, if you are on a \*nix system you probably already have it.

Type `vim -v` in a terminal to see if vim is installed, you'll see something like:

```
VIM - Vi IMproved 8.1 (2018 May 18, compiled Oct 29 2018 06:56:05)
macOS version
Included patches: 1-500
Compiled by Homebrew
Huge version without GUI.  Features included (+) or not (-):
...
```

If you don't have vim installed you can install it from [here](https://www.vim.org/download.php).

Open terminal and type: `vim vim-basic`.

congrats! you are using vim ha!

## VIM modes
Vim is a "modal editor", which means vim will behave differently depending on which mode you are currently on.

I'll introduce you to three basic modes. **NORMAL**, **INSERT** and **VISUAL**. There are a couple more, but these are the basics ones, and they are all you need to know for now.


## NORMAL - The default vim mode

This is where you'll spend most of your time and it's the mode where the magic happens. In this mode you can execute commands.
Commands can be a simple letter, for example if you press the letter `j` you'll see your cursor goes down one line and if you press the letter `k` it will go up.
In this mode you'll do things like navigate through your text file, removing, copying and pasting text.

### Navigation
While you are in **NORMAL** mode you would need to move around your text file. These are the basics commands that will help you achieve that.

```
      k
      ^
  h < + > l
      v
      j
```

### Removing text
  dd - delete the current line.

### Copy text
  yy - copy(yank) the current line.

### Pasting text
  `p`  - paste to the line underneath.


## INSERT - The mode where you can "insert" text
  You probably were wondering, how do I actually write something into vim, well... this is the mode where you can do that.

  You enter INSERT mode by pressing the letter `i`. In this mode you'll use your keyboard like in any other editor, vim will not behave in a special way when you are in this mode.

  In vim, you are not expected to be in this mode all the time Whenever you finish your writing you go back to **NORMAL** mode, you do that by pressing the **ESC** key.

  After writing or editing your changes you'll probably want to save your file and quit vim.
  Press **ESC** and go back to normal mode, then you could write any of the following commands:

  * `:w`  - Save your changes.
  * `:q`  - Quit vim.
  * `:q!` - Quit vim even if your changes were not saved.


## VISUAL - The mode in which you can select chunks of text
 While in normal mode you enter the visual mode by pressing the letter `v`. You'll notice that the text will highlight if you go up, down, left or right.

 You could select a paragraph, a single word or even a letter and apply commands to that selected piece of text. You could copy(yy) a selection of text or delete (dd) it if you wish. To exit visual mode you press `ESC` and will return to **NORMAL** mode.


## Resources
 These are a couple of resources that can help you improve your vim skills.

  * vimtutor                   - If you are on a \*nix system you can type in the terminal `vimtutor` for a vim tutorial.
  * http://vim-adventures.com/ - A game that will teach you vim
  * `:h` or `:help`                   - Vim's go to help command


## Conclusion
 This is a really basic introduction to vim and it's just the tip of the iceberg of what vim really can do. I hope this little introduction will motivate you to keep learning vim and showed you that to start using vim you only need a couple of concepts and commands.
