---
layout: post
title: vim Basics
date: 2019-07-29 22:28:02
categories:
author: bronzdoc
---

# VIM basics

I would not bore you by telling you the history of vim, and the differences between vi and vim and all of its unix philosophy....
If you are interested in that, you can give it a look [here](https://en.wikipedia.org/wiki/Vim_(text_editor).

So all you need to know is that vim is a text editor. In my opinion one of vim's strengths comes with how flexible it can be. It can be as simple or complex as you wish. It can be used to edit a simple config file on a server or you can make it a complete code editing environment.

In this blog post I'll show you the basics of vim and provide you with the smallest amount of knowledge necessary to make vim useful for yourself, and yes I'll teach you how to exit ;)

I'll assume you already have vim installed, if you are on a \*nix system you probably already have it.

Open terminal and type: `vim vim-basic`.

You'll see something like the following:
```
                                                      VIM - Vi IMproved

                                                       version 8.1.500
                                                   by Bram Moolenaar et al.
                                         Vim is open source and freely distributable

                                                Help poor children in Uganda!
                                        type  :help iccf<Enter>       for information

                                        type  :q<Enter>               to exit
                                        type  :help<Enter>  or  <F1>  for on-line help
                                        type  :help version8<Enter>   for version info

                                                Running in Vi compatible mode
                                        type  :set nocp<Enter>        for Vim defaults
                                        type  :help cp-default<Enter> for info on this
```

congrats! you are using vim ha!


## VIM modes
Vim is a "modal editor", which means vim will behave different depending on which mode you are currently on.

I'll introduce you to three basic modes. **NORMAL**, **INSERT** and **VISUAL**. There are a couple more, but these are the basics ones, and they are all you need to know for now.


## NORMAL - The default vim mode

This is where you'll spend most of your time and it's the mode where the magic happens. In this mode you can execute commands.
Commands can be a simple letter, for example if you press the letter `j` you'll see your cursor goes down one line and if you press the letter `k` it will go up.
In this mode you'll do things like navigate trough your text file, removing, copyieng and pasting text.

### Navigation
While you are in **NORMAL** mode you would need to move around your text file. This are the basics commads that will help you achieve that.

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
  p  - Paste to the underneath line.


## INSERT - The mode where you can "insert" text
  You problay were wondering, how do I actually write something into vim, well... this is the mode where you can do that.

  You enter INSERT mode by pressing the letter `i`. In this mode you'll use you keyboard like in any other editor, vim will not behave special when you are in this mode.

  In vim, you are not expected to be in this mode all the time Whenever you finish your writing you go back to **NORMAL** mode, you do that by pressing the **ESC** key.

  After writing or editing your changes you'll probably want to save your file and quit vim.
  Press **ESC** and go back to normal mode, then you could do the any of following:

  * :w  - Save your changes.
  * :q  - Quit vim.
  * :q! - Quit vim even if your changes were not saved.


## VISUAL - The mode in which you can select chunks of text
 While in normal mode you enter this mode by pressing the letter `v`. You'll notice that the text will highlight if you go up, down, left or right.

 You could select a paragraph, a single word or even a letter and apply commands to that selected piece of text. You could copy(yy) a selection of text or delete (dd) it if you wish. To exit visual mode you press `ESC` and will return to **NORMAL** mode.


## Resources
 These are a couple of resources that can help you improve your vim skills.

  * vimtutor                   - If you are on a \*nix system you can type in the terminal `vimtutor` for a vim tutorial.
  * http://vim-adventures.com/ - A game that will teach you vim
  * :h :help                   - vim go to help command


## Conclusion
 This is a really basic introduction to vim and it's just the tip of the iceberg of what vim really can do. I hope this little introduction will motivate you to keep learning vim and showed you that to start using vim you only need a couple of concepts and commands.
