---
layout: post
title: "Introducing Infractores"
date: 2016-04-26 10:37:00
categories: ["open-source", "crowdsourcing"]
author: "etagwerker"
---

I've always been a big fan of [scratching your own itch](https://en.wikipedia.org/wiki/The_Cathedral_and_the_Bazaar#Lessons_for_creating_good_open_source_software). My latest itch was the **insane amount of parking
infractions** that I see everyday in **Buenos Aires**, near [our office](https://foursquare.com/v/ombulabs-hq/52f0e47311d25da04d101b62).

We decided to build a **simple tool** that would allow anyone with a [Twitter](https://twitter.com) account to *report a parking infraction*. You just
need to submit a **tweet with Geolocation** enabled and a couple of
photos (**evidence!**)

Here is an example:

<blockquote class="twitter-tweet" data-lang="en"><p lang="es" dir="ltr">Ah, ¿no se puede estacionar en paradas de colectivo? Ya fueee... <a href="https://twitter.com/hashtag/InfractoresBA?src=hash">#InfractoresBA</a> <a href="https://t.co/XXmu1pdAib">pic.twitter.com/XXmu1pdAib</a></p>&mdash; E r n e s t o (@_nesto) <a href="https://twitter.com/_nesto/status/722065061309726720">April 18, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

You can check out this tool over here: [http://www.infractoresba.com.ar](http://www.infractoresba.com.ar)

This page shows all the valid parking infractions reported by users to
[@InfractoresBA](https://twitter.com/infractoresBA) or with the
[#InfractoresBA](https://twitter.com/search?src=typd&q=%23InfractoresBA) hashtag.
It's **as simple as that**.

<!--more-->

We focused on making the feature of reporting a parking infraction **as simple as
possible**:

* You don't need to download an application
* You don't need to register anywhere
* You don't need to fill out twenty fields

I know that there are *other alternatives* to report an infraction in Buenos
Aires:

* An official [Android and iOS application](http://www.buenosaires.gob.ar/aplicacionesmoviles/ba-denuncia-vial)
* An official [web page with a long form](http://www.buenosaires.gob.ar/areas/seguridad_justicia/seguridad_urbana/dgcactyt/formulario_denuncia/denunciavial.php?menu_id=34064)

But I wanted to make it even easier for someone to report an infraction. I am
also a big fan of (good) **user experience**.

I didn't see the need to register an account to report an infraction. In fact,
I think it's something that will stop a lot of people from reporting an issue.
Why not use an existing account in Twitter?

As a user of our tool, and as someone who usually rides his bicycle to work, I
wanted to **stop, take a photo, send out a tweet, and move on**.

Just like this:

<blockquote class="twitter-tweet" data-lang="en"><p lang="es" dir="ltr">La gente que estaciona así es un peligro <a href="https://twitter.com/InfractoresBA">@InfractoresBA</a> <a href="https://t.co/DGNfrQvopZ">pic.twitter.com/DGNfrQvopZ</a></p>&mdash; E r n e s t o (@_nesto) <a href="https://twitter.com/_nesto/status/717023979454771201">April 4, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

There is still some work to be done. That's why we have made this tool
[open source](/blog/tags/open-source/). We are open to suggestions, bug reports, code contributions and general feedback: [https://github.com/ombulabs/infractores](https://github.com/ombulabs/infractores)

As always, we developed an [MVP](http://www.ombulabs.com/blog/tags/mvp) that can
later be extended and refined. We hope to learn from the community and usage of
this tool.

Our vision is for someone to pick up this tool, configure a city and a vertical,
and start using it to track any kind of infractions.

In our case, we wanted to improve the situation with parking infractions in
**Buenos Aires**. We expect this tool to punish the people who park in **illegal
places** and encourage more people to **park better**.

However you could easily configure this tool to track *loud noise infractions* in
**Chicago**, or *crime* in **Berlin** (in terms of crime it will be tricky to
capture the image/video to use as evidence, but it's a possibility)

This is **not a commercial project**. We **don't** expect to make money, we just
want people to use it to **improve their community**.

Please let us know if you see any [issues](https://github.com/ombulabs/infractores/issues), if you like it, or if you hate it!
