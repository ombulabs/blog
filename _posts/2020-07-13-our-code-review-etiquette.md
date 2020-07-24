---
layout: post
title: Our Code Review Etiquette
date: 2020-07-13 09:30:00
categories: [best-practices]
author: cleiviane
---

Code Review is one of the greatest tools we have as software developers to help us improve the quality of our code. It can be incredibly beneficial, but it can also be a source of pain, frustration, and overall, a waste of time instead of a time-saver.

Because of that a while ago we wrote these code review tips that should be acknowledged and incorporated by everyone in our team and now we want to share them with you.

<!--more-->

Code Review it’s a way of sharing responsibilities and learn from each other. It’s where we can catch bugs and mistakes and it's also a way to enforce broadly agreed code standards between team members.

But besides knowing what code review is for, we need to know what code review isn't for:

- It is not the place for shooting at your teammates and pointing fingers at their mistakes.
- It is not a place for you to try to force your opinion.
- It is not where discussions should occur.

#### What you need to know about reviewing?

- Accept that many programming decisions are opinions.
- You can trust your teammates. They can have their own personal decisions on the code and remember that each problem can have more than one solution that may not be your solution.
- Ask good questions and don't make demands. <i>"What do you think about naming this user_id?"</i> it’s nicely than <i>"You should rename this variable to user_id"</i>
- Good questions avoid judgment and avoid assumptions about the author's perspective.
- Ask for clarification: <i>"I didn't understand. Can you clarify?"</i>
- Avoid selective ownership of code: "mine", "not mine", "yours"
- Avoid using terms that could be seen as referring to personal traits: "dumb", "stupid", “not smart”. Assume everyone is intelligent and well-meaning.
- Be explicit. Remember people don't always understand your intentions online.
- Be humble: <i>I'm not sure - let's look it up.</i>
- Don't use hyperbole: "always", "never", "endlessly", "nothing"
- Don't use sarcasm. Even if it is your buddy.
- Keep it real. If emoji, animated gifs, or humor aren't you, don't force them. If they are, use them with aplomb.
- Talk synchronously (e.g. chat, screen sharing, in person) if there are too many comments like "I didn't understand" or "Alternative solution". Then post a follow-up comment summarizing the discussion.
- Before submit your review make sure you have considered <a href="https://www.ombulabs.com/blog/software-development/software-quality/our-definition-of-done.html" target="_blank">Our Definition of "Done"</a>.

#### When you are reviewing

- Understand why the change is necessary (fixes a bug, improves the user experience, refactors the existing code).
- Be respectful. Keep in mind that there’s a person on the other side of the wire, not a machine, and that it’s hard to understand written words with little context. Avoid letting anger and frustration leak into the review, even if you feel it is justified. There’s no good outcome in those situations.
- Communicate which ideas you feel strongly about and those you don't.
- Explain why. Unless the change is about an extremely obvious mistake, explain why you’re suggesting it.
- Identify ways to simplify the code while still solving the problem.
- If discussions turn too philosophical or academic, move the discussion to another channel (chat or in email maybe?). In the meantime, let the author make the final decision about the implementation.
- Avoid trivialities. Think to yourself: all things considered, does it actually matter? Is the cost of the author’s time, and the potential debate, really worth it?
- Praise the good work. You can praise the logic, design, code organization, or whatever else that you honestly felt was well done.
- Offer alternative implementations, but assume the author already considered them: <i>"What do you think about using a custom validator here?"</i>
- When trying to offer alternative solutions, always link to resources if possible to help ensure that the claims being raised are validated.
- Seek to understand the author's perspective.
- Read the commit messages if you don't understand something. It's useful to try to understand why the author decided to do something.
- It’s OK to say it’s all good. That doesn't hurt your reputation or mean that you are a less thoughtful reviewer. If the code is okay, just sign off on the pull request with a 👍 or "Ready to merge" comment.


#### When you have your code under review

- Be grateful for the reviewer's suggestions: "Good call. I'll make that change."
- A common axiom is <i>"Don't take it personally. The review is of the code, not you."</i> We used to include this, but now prefer to say what we mean: Be aware of how hard it is to convey emotion online and how easy it is to misinterpret feedback. If a review seems aggressive or angry or otherwise personal, consider if it is intended to be read that way and ask the person for clarification of intent in private.
- Write good commit messages. Not just "Added x file", but "Added x class" or "Fixing x bug" if writing a summary, and if it's a complicated/weird bug that took you a while, write a long commit message with references or an explanation.
- Keeping the previous point in mind: assume the best intention from the reviewer's comments.
- Communication is the key. Give your reviewers context about your changes.
- Explain why the code exists: "It's like that because of these reasons. Would it be more clear if I rename this class/file/method/variable?"
- Extract some changes and refactorings into future tickets/stories.
- Push commits based on earlier rounds of feedback as isolated commits to the branch. Reviewers should be able to read individual updates based on their earlier feedback.
- Seek to understand the reviewer's perspective.
- Try to respond to every single comment. Don’t ignore a comment you did not like.

#### Enjoy!

Make sure you’re enjoying what you do, and appreciate what your code reviews are achieving. There’s little point in playing the role of an intelligent computer over extended periods of time if you are unhappy about it. Get yourself your preferred slow-drinking beverage (coffee?), perhaps some snacks, a comfortable chair, and relax.

#### References

1. [How to do Code Review - André Arko](https://andre.arko.net/2020/01/24/how-to-do-code-review/)
2. [The Ethics of Code Reviews](https://marcotroisi.com/the-ethics-of-code-reviews/)
3. [The Standard of Code Review](https://google.github.io/eng-practices/review/reviewer/standard.html)
