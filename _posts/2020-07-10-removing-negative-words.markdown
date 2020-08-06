---
layout: post
title: "Removing Negative Words From Our Codebase"
date: 2020-07-10 11:00:00
reviewed: 2020-07-10 11:00:00
categories: ["inclusion", "culture"]
author: "abizzinotto"
---

The discussion around the use of problematic words / terms in technology isn't a new one. This issue [can be traced back to, at least, 2003](https://edition.cnn.com/2003/TECH/ptech/11/26/master.term.reut/) when a Los Angeles county worker filed a complaint with the city's Office of Affirmative Action Compliance after seeing "master" and "slave" in computer equipment labels.

This issue has resurfaced with recent events and, at OmbuLabs, we believe it is important to take it seriously. It is past time to remove this metaphore from our codebase and review some of the terminology we use. We have started taking the necessary steps to rename "master" branches to "main", as well as (and perhaps more importantly) remove any reference to the term "slave" and replace "whitelist / blacklist" with "allowlist / blocklist". Our team is actively working on that.

But we understand that is not enough. This is not an action that will solve racism by itself. It's part of a larger commitment. In this article, I'll explain the context and motivation for this change and how it fits with our core values and long term vision as a company.

<!--more-->

## Context

As far as the software community is concerned, efforts to move away from such terms have been underway for quite some time now. In 2014, [Drupal](https://www.drupal.org/) opted for the use of "primary / replica" instead of "master / slave" and, in the same year, [Django] (https://www.djangoproject.com/) opted to use "leader / follower". Then in 2018 the decision was made to remove the terminology from Python, in the same year the IETF (Internet Engineering Task Force) published their [Terminology, Power and Oppressive Language](https://tools.ietf.org/id/draft-knodel-terminology-00.html#rfc.section.1.1) memo arguing for the terminology change and offering alternatives to be use instead of the offensive terms.

Because of the current societal reckoning with racial injustices, the discussion has resurfaced, and recently several communities and companies of all sizes have been making the change (examples include OpenZFS and Go) or making a commitment to change, with GitHub's CEO claiming [in a Tweet](https://twitter.com/natfriedman/status/1271253144442253312) that his team has already been working on transitioning from "master" to "main" for default branch structure. The Android and Chrome teams have also been determined to replace "whitelist / blacklist" with "allowlist / blocklist".

Not everyone in the community agrees with the change though. When Python moved away from the terminology in 2018, there was a heated discussion over it, with several members of the community questioning the change and its real impact. Before that, the issue had already divided the Redis community.

It is necessary to keep in mind that in order to completely replace the terms in question, there needs to be an industry wide decision to stop using them. As long as there are still projects that haven't moved away from the terminology, it won't be completely wiped out. A good example is Kubernetes. Although it uses "replicas", "workers", and "minions" instead of "slaves", [as pointed out by Sinclair Im in a Washington Post editorial](https://www.washingtonpost.com/opinions/2020/06/12/tech-industry-has-an-ugly-master-slave-problem/), "its code repository still contains more than 200 lines that use ‘slave.’ Because its code must talk to others, even Kubernetes can’t completely avoid the terminology".

As such, it is important to have the discussion around the necessity of this change, its motivation and its impact. Of course large corporations can simply get their executives to issue a top-bottom order forbidding the use of these terms. But it might prove difficult to convince independent developers and smaller projects to adopt the new terms, and quickly.

Avoiding the discussion does very little to raise awareness to and promote the actual understanding of the issue. It is important to explain the arguments behind it and address the concerns around it.

In an effort to do that, I'll talk a bit more about motivation and the arguments supporting the change.

## Motivation

As previously mentioned, this is far from a recent issue. It is, however, seeing more and more adoption lately. And more questioning.

The motivation to move away from "whitelist / blacklist" is pretty clear. The use of black and white in this context has nothing to do with color or light, and everything to do with the perception that black is bad and white is good, which is deeply rooted in racism. There is no good reason to use a metaphor when there are clear, descriptive terms to be used instead. Let alone use a racially charged one.

Moving away from the "master / slave" terminology, however, has seen more controversy. As such, the following sections will be dedicated to that particular change.

As Matthew Ahrens explains in his [pull request](https://github.com/openzfs/zfs/pull/10435) removing all possible references to the term "slave" from OpenZFS' `zfs` repository:

> The horrible effects of human slavery continue to impact society. The casual use of the term "slave" in computer software is an unnecessary reference to a painful human experience.

Empathy in itself is a pretty good motivation for change and knowing that these terms are hurtful and can easily be replaced is sufficient to prompt us to act. However, we also believe in understanding why we are doing things and how what we are doing fits with our company culture and purpose. Simply following the trend without questioning why it's important, how it's beneficial and where it fits in a bigger picture context isn't enough.

Understanding these points is paramount to create a culture of ambassadors of change. Questioning, done with an open mind and actual desire to understand, is healthy and desirable.

### Why is a change in language needed?

There is an intrinsic relationship between language and power. And there is an unstoppable evolution in language. Every day, new terms arise and old terms become obsolete.

The "master / slave" metaphore is clearly connected to slavery. The metaphore adopted in technology isn't master / copy, or master / student. The term master has several different meanings and it isn't, in itself, problematic. However, when used together with slave, in a metaphore referring to the "master / slave" relationship, it becomes a problem.

The term "master" as used in git is also not used in the context of mastery of knowledge or even the original copy. As Bastien Nocera points out in his [email in reponse to the proposal to remove the "master" name from GNOME repositories](Bastien Nocera), the term "master" first appeared in git in a [CVS helper script](https://github.com/git/git/commit/3e91311ae750af9bf2e3517b1e701288ac3066b9) and was likely chosen because [BitKeeper uses "master" for its main branch](http://www.bitkeeper.org/tips.html#_how_do_i_rebase_my_work_on_top_of_a_different_changeset). According to BitKeeper's documentation, the term is a reference to the master / slave relationship, [as they refer to master / slave repositories](https://github.com/bitkeeper-scm/bitkeeper/blob/master/doc/HOWTO.ask#L223) and, in BitKeeper, [repositories and branches are the same thing](https://users.bitkeeper.org/t/branching-with-bk/158/2).

Therefore, the software industry have been casually using the master / slave relationship on a daily basis.

As outlined by IETF in its memo, in order to effectively communicate, it is important to make the information accessible to all readers, and this implies evaluating whether the words and terms used will hinder the reader and get in the way of effective communication. Using terminology that is negative and can trigger an emotional response gets in the way of clear communication and should, therefore, be avoided.

Additionally, if we're to not think of anything but clarity, the "master / slave" usage in the context of human slavery far predates its use in software and engineering. And there's no descriptive relationship between human slavery and software.

Finally, the effects of slavery are still impacting society today in the Americas, where slavery was deeply tied to racism. People continue to experience racial injustice and systemic racism today. But that is not the sole motivation for this change. Slavery itself is still very much a problem today.

As of last year, [the United Nations reported over 40 million people were victims of modern slavery](https://news.un.org/en/story/2019/09/1045972). Human trafficking, for labour or sexual, exploitation is still a problem, with victims held captive in slave-like conditions. Far from being an issue exclusive to under-developed countries, reports of human trafficking rings active in Europe and North America can be found with a simple Google search.

Therefore, these terms should not be casually used in any context. They represent a horrible problem humanity still experiences, be it in the form of modern slavery or the issues still faced by people of colour stemming from the condition their ancestors were subjected to. There is no real necessity to use them in technology, as there are several other pairs that are just as descriptive without being offensive.

### Why is this important?

In a community where open-source projects are a reality, that advocates and pioneers change and challenges established premises, the use of controversial terminology (especially when done unnecessarily) is counter-intuitive.

It is important to set the path to completely wipe out these terms, to foster a more inclusive environment, to encourage professionals of diverse backgrounds to feel safe and drive more people to the industry. We can only benefit from diversity and inclusion. So why not foster it?

The casual use of "master / slave" is not only problematic due to the obvious racial issues stemming from slavery, but also because slavery is still very much an issue. What if the next developer to join the team happens to have escaped modern slavery conditions? We'll be forcing someone to use these terms on a daily basis for no good reason. That isn't very inclusive.

### Why is this so important to us?

Although we understand a change in terminology is far from being enough, it is important as part of a bigger context. We foster and encourage diversity. Our team includes members from 4 different countries with different background and experiences. We are making an actual effort to be open and create equal opportunities.

As such, at OmbuLabs this change is closely tied to our [core values](https://www.ombulabs.com/blog/values/our-values.html) and company culture.

**We put our team first.** This means valuing and respecting each team member as well as fostering a welcoming and open work environment. Using words that contribute to a hostile work environment goes directly against that core value. We are changing this terminology to ensure nobody in our team, now or in the future, is made to feel bad by the casual use of these terms.

**Talent is everywhere.** Geographical boundaries won't stop us. Language ones shouldn't either. We must be inclusive of every person, of every culture, of every background. Using racially charged metaphores and terminology with heavy, negative historical connotation fails to meet that core value.

**Open by Default.** We want to be open, to communicate openly and to give back to our community. It is important to use language that is in line with that. Facilitating communication is the goal and moving away from words that get in the way of effective communication is key to achieving that.

**Continuous Improvement.** We vow to keep improving. Not only in our code but in our culture. Not taking the necessary steps to drive positive change now is simply not in our core.

## Conclusion

We have listened to the community. We have seen the trends. And we're committed to doing our part and raising awareness while we're at it.

This is not an isolated initiative. OmbuLabs is committed to sustaining an open, diverse and inclusive work environment as a whole. This is one facet of that environment, and an important one.

There are several arguments, human and technical, to move away from negative terminology. I hope this article helps you not only understand why we're doing this, but to advocate change in your projects and help us change as a community.
