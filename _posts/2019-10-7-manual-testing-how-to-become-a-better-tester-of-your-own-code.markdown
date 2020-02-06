---
layout: post
title:  "Manual Testing: How to become a better tester of your own code"
date: 2019-10-7 15:00:00
categories: ["software-development", "software-quality"]
author: abizzinotto
published: false
---

Manual testing is a necessary part of software development and quality assurance. And although it's important to have a dedicated tester in your team, you as a developer can also help speed up QA, and thus the software development process, by becoming a better manual tester of your own code.

But how to do that? I'll cover 4 simple points that will help you get there!

<!--more-->

Manual testing is a necessary part of software development and quality assurance. It’s true that it is prone to errors, after all, every human activity is, and can also be time-consuming and boring. It’s also true that automated testing reduces testing time a great deal and is more reliable. But automated tests can only go so far. Human intuition and curiosity cannot be replaced by an automated task.

Therefore, it is important to have a software tester in your team who knows not only the application but also the end user well. This person will be the “official” manual tester and will find those edge cases for you. But, as a developer, it is also important for you to stay on top of things and manually test your own code before moving on to the Quality Assurance phase. This way, you can ensure your code does exactly what it was intended to do.

Here at [OmbuLabs](https://www.ombulabs.com) we follow some principles and guidelines to manually test our own code before it goes to QA. In this post, we’ll walk you through these guidelines.

##It all starts with the user story

Here at OmbuLabs we work with user stories. And every user story has a definition and a scope. Therefore, we have a bug that needs to be fixed, a feature that needs to be added, a chore that needs to be performed, and other situations specific to the project. What all of these have in common is they present a problem to be solved. As such, there is a specific result or outcome that is expected.

Now, we have automated tests in place to make sure a feature does what it needs and produces the expected outcome or a bug fix actually fixed the bug. But there are aspects that need manual testing. How does it look on the screen? What if the user decides to follow an alternate path to get the same result?

When manually testing your own code, always go back to the user story and go through the intended flow. Does everything work as expected? Do you see exactly what you’re supposed to see? Is it easy enough for a non-technical person to follow those steps? Where could errors happen? What are the edge cases that a non-technical user could try?

##Write manual tests beforehand

It won’t be possible to just think of all the possibilities and note them down. It isn’t even practical. But it’s always a good idea to take some time to think of the actual actions to be taken by the user to use the feature you’re coding or the one impacted by the bug you’re solving.

This also needs to be done together with the Product Owner (Client). So when defining a story, use the description area to describe manual tests to be run before moving it to QA. This also helps prevent bias from impacting the quality of the tests. If you write manual tests after coding the feature or just test without writing tests, you’ll be unconsciously biased since you’ll be conditioned to follow the same thought process you followed when coding. As as we know, users are very good at not using the software the way it was intended by the developer.

When writing manual tests, however, make sure to pay attention to tasks that can be automated. Manual tests are a necessary part of software development but it should be reserved to tasks that cannot be automated.

##Leave some time between finishing coding and running the tests

Finished working on your story? Great! Take some time to either go on a break or work on something different before manual testing. This buffer will make the task a little less boring (specially if the story was big or challening) and will reduce bias.

##Ask questions

It is important to keep in mind that the Product Owner (client) might not be a very technical person. They might not even be technical at all. Additionally, they know what they want that feature to accomplish or that bug to solve, or how the end user will interact with the software, but they might not fully understand how much of that knowledge is not being passed on to the development team.

As such, if you are unsure the path you’re following is the intended one, or the tests you’re running are enough, ask questions.

Your code will still go through QA and additional manual tests will still be run by the teams’ tester, but these steps will make you a better tester of your own code and assure it reaches the next step in development in better shape!
