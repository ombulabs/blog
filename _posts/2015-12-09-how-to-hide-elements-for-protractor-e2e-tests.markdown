---
layout: post
title: "How to interact with hidden elements with Protractor"
date: 2015-12-09 03:55:00
reviewed: 2020-03-05 10:00:00
categories: ["protractor"]
author: "etagwerker"
---

The other day I was trying to interact with a hidden file input field:

```html

<div class="col-sm-3">
  <input class="btn btn-default" class="hidden" accept=".csv"  id="geofence_file_input">
  <a class="btn btn-default" id="textbox-for-geofencefile">Select File</a>
  <span ng-if="LineItemForm.augmentations.geofence.file">{{selectedFilename()}}</span>
</div>

```

And the CSS:

```css

.hidden {
  display: none;
}

```

Which caused this problem:

    Failed: Wait timed out after 100015ms

Workarounds include _displaying it_, _interacting with it_, _hiding it_ again, which I didn't like.

<!--more-->

I changed it to be like this, more **protractor-friendly**:

{% highlight html %}

<div class="col-sm-3">
  <input class="btn btn-default" style="opacity:0;height:0px;" accept=".csv"  id="geofence_file_input" type="file">
  <a class="btn btn-default" id="textbox-for-geofencefile" ng-click="selectFile(this)">Select File</a>
  <span ng-if="LineItemForm.augmentations.geofence.file">{{selectedFilename()}}</span>
</div>

{% endhighlight %}

Or with CSS:

{% highlight css %}

#geofence_file_input {
  opacity:0;
  height:0px;
}

{% endhighlight %}

Now it works and the tests do too.
