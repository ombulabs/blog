---
layout: post
title: "What we Learned Developing a Snapchat Mini (Part 1)"
date: 2020-07-27 12:00:00
categories: ["learning"]
author: arieljuod
---

Over the last few months, we were making a Snapchat Mini <!-- I'll link to Amanda's post -->. Minis are small static web apps that are run inside a webview within the Snapchat native app.

One important part of the development was to make sure our mini works well across different devices, especially making sure things work the same in both Android's webview (Chrome by default) and iOS's webview (Safari).

In this post I'll talk about a few things to keep in mind when working with the Span canvas SDK and also some common and known issues you'll encounter when making your app cross-mobile-browser compatible.

<!--more-->

## Working with the SDK

Snapchat provides a JavaScript SDK that you'll have to include in your project. This SDK works as a bridge between the native app and your web app and lets you trigger native functionalities (like sharing on chat and camera), it gives you information about the current user and session, and also sends different events so you can react to them (you can detect if a user takes a screenshot or changes the volume for example).

### Initializing the SDK

Along with the sdk files, you'll have the documentation and the manual to help you set up the sdk initialization. The process is simple and it's explained in the manual so I won't go over that here. But, since you'll be probably developing the app mainly in a desktop/laptop computer, one thing you should keep in mind is that the initialization callback won't be triggered outside the native app. If your app depends on the SDK being initialized to work properly, you'll have to implement a fallback mechanism to trigger the same callback locally.

There are many different ways you can do this depending on what you use to create the mini. If you use Node, you can check Node ENV variables within the current process for example. If you use Webpack you can use conditionals to include different code depending on the environment. If you use none of them, you can check if the current domain is `localhost` if that applies in your dev environment.

### Fallback Method Calls when Working Locally

When developing, since the SDK won't be connected to a native app, you'll have to handle some fallbacks in the places where you need to call SDK methods (like when sharing to camera, chat, etc) if you want to test the app flow easier.

For example, if your app uses the share-to-chat functionality, if you call the SDK method responsible for that locally, it will throw an exception. If you need to respond to that action to, for example, change to a different state, you may need to implement a fallback mechanism. You can `try/catch` the exception for example, or check if `sc.app` is defined or not (in this case, `sc` is the variable containing the sdk instance and the `app` property is an object with information of the native app, that won't be populated when running locally).

### Displaying a Sticker when Sharing Content Using the Camera

To share content using the camera, the SDK provides a method that you can call passing a `Sticker`, this is a class defined by the SDK that contains some meta data for the sticker and the content of the actual image file base64-encoded.

Depending on your design and what you want to show as the sticker, you can have the base64 string hardcoded. This may not be the best idea because it will increase the size of your JavaScript code even for users not using that functionality.

For us, a better solution was to use the HTML Canvas element to draw an image and get the base64 encoded image data on the fly only when needed. We had to use the full power of the canvas element to draw more things like rendering text, lines, background, etc. Then, after everything was drawn, we could get the base64 data url.

If you need to implement the share-to-camera functionality, it's not easy to test the sticker generation while you are developing it. To help us create the sticker more easily, we used this simple snippet:

```javascript
let base64data = generateStickerData()
if (sc.app) {
  // this method will prepare the sticker object and call the SDK methods
  shareStickerUsingSDK(base64Data) 
} else {
  // this will show an IMG element during development locally, so we can see what we created
  previewImage.src = base64data
}
```

This speeds up the sticker design process a lot! since we don't need to publish the mini to test it inside Snapchat. After we were happy with the generated image, we started testing the real sdk method calls by publishing the mini to be used inside Snapchat.

## Embrace the Asynchronous Nature of JavaScript

If you are coming from other programming languages, you may find it hard to work with callbacks (you may end up falling into the [Callback Hell](http://callbackhell.com)). Instead of trying to adapt the SDK methods to a synchronous nature, we found it's a lot simpler to use modern JavaScript techniques to handle asynchronism. We tried to reduce callbacks using Promises and we also used reactive JavaScript frameworks like VueJS or ReactJS so we could update the app's state asynchronously and let those frameworks update the views.

## Storing Data

Depending on the nature of the mini, you may need to store some data related to the user's state/actions (you may want to store an ID you get from a service, a timestamp when a user did some action, etc). We needed to store if a user had already done one specific action. For simple data like this, you can use the SDK's provided methods to write and read the local storage. Don't confuse this with the browser's local storage API: the local storage provided by the SDK is similar in some aspects but (apart from a few small differences) it has an async nature while the browser's locale storage is synchronous.

You can use it to store simple string key/value pairs. You can store small and simple object by stringifying them first, but you shouldn't abuse this.

If you need to store more data, more complex data, or if you need a database to share data between users, you'll need to handle that within your own infrastructure.

## Native Look and Feel

We wanted this mini to look and feel like it was a native app. Some key considerations were: the design should not look like a website; sizes, color, animations and transitions should feel similar to what native apps do; and we wanted a scrolling behavior that didn't feel like a website.

For the animations and transitions, we used CSS animations/transition properties initially, but we also needed to create some animations that were too hard to handle with just CSS and custom made JavaScript, so we used [VelocityJS](http://velocityjs.org) for that.

For the design, we had an iterative process, the design was changing during development to make it feel more native while we were adding features.

For the scrolling, we implemented a custom scroll on one of the apps because it relies too much on swiping and scrolling gestures and the default scroll was not enough for our needs. This was developed with this mini's requirements in mind so it's something that probably won't work for other minis to share what we did, but the main idea is to listen to the touch events (start, move, stop, cancel) and use the positions to detect the gestures and scroll the elements accordingly. We also added some inertia similar to the default scroll when releasing the touch.

You can try to add support for similar mouse events (desktop Safari mobile simulation mode does not trigger touch events like Chrome does for example), but minis are only going to be run inside touch devices. It could help you during development when testing inside desktop Safari if you need that.

## Performance

One of the apps was animation-intensive: colors changing, text scrolling, different parts could move at the same time, some actions would trigger big changes on the layout, etc.

It was really important to measure and test the performance. The most important tool we used for this was Google Chrome's `Performance` profiler in dev tools. You can profile the app while doing specific actions and then inspect it frame by frame to make sure of what you need to optimize to have smooth animations.

Remember that your mini will run in a variety of devices from high to low end, you will want to make sure everyone will have a good experience.

## Making the App Work in iOS and Android Webviews

Some of these issues are related to mobile web development in general, it's not something specific to Snapchat, but since you'll want your mini to work properly for all users you'll have to make fixes for specific issues you may encounter for each webview implementation. Chrome for Android is different than desktop Chrome, and Mobile Safari is different than desktop Safari, you can fix most of the issues using desktop browsers but you'll have to test them in the mobile browsers.

We'll go over a few common issues you'll encounter and some solutions we implemented.

### VH Units

We wanted the app to use 100% of the available vertical space. Usually, if you want to do that, you'll use `height: 100vh`, but mobile Chrome and mobile Safari may use a different value than what you would expect in the desktop applications. They'll use the screen size instead of the actual viewport height.

This is an excellent resource for this issue with a few tips and tricks: [link](https://css-tricks.com/the-trick-to-viewport-units-on-mobile/)

### Keypress/release/up/down Events are not Triggered for Mobile Chrome

When you type using Android's default keyboard app, it won't trigger the usual key-related events. Depending on your needs, you may add an event listener for the `input` or the `change` events instead.

### MAXLENGTH Attribute won't Work on Mobile Chrome

If you have an input where you want to limit the value's length, the best way to do that normally is to use the input's `maxlength` attribute. That will limit the length disallowing the user to type more characters than expected. But, when typing on an Android device, it won't respect that limit.

Normally, you would work around an issue like this listening to the `keypress` event and preventing it's default behavior depending on the pressed key and the element's value length, but since we can't relay on the `keypress` event we implemented another workaround using the `input` event:

```javascript
onInputChange(e) {
  // if the length is greater than the limit we want
  if (e.target.value.length > our_length_limit) {
    // store current cursor position
    let cursorPosition = e.target.selectionStart

    // truncate the value
    e.target.value = e.target.value.substring(0, our_length_limit)

    // restore cursor position
    e.target.setSelectionRange(cursorPosition, cursorPosition)
  }
}
```

If you use an element that's not an input with the `contenteditable` attribute, you may need to do some changes to that snippet in order to get the current cursor position from the document element.

### Changing Input Case Breaks iOS Keyboard Suggestions

One initial requirement we had for an input element was that it should always by uppercase characters. The easiest solution for this requirement would be to use a CSS text transform property:

```css
#my-input {
  text-transform: uppercase;
}
```

But this creates an issue. This modifies the element's value and iOS keyboard loses track of the original word it has to replace if you select one of the suggestions, not being able to actually apply the suggestion.

We also tried a different solution for that requirement listening to the `input` event and upcasing the letters after the input changed, but this creates the same issue for iOS' keyboard suggestions.

One solution we didn't try (because it would be too hacky and we decided to remove the requirement) is to have 2 different inputs, one where the user will actually type (hidden somehow using `visibility: hidden`) and one that shows the original input value but upcased.

I would advise not to have that requirement unless it's critical to your app or if you don't mind having the keyboard suggestions functionality broken on that input for iOS.

### DONE Key on iOS is not a Key

iOS keyboard shows a `DONE` "key" as a part of the keyboard, but this does not work like a key, you can't detect it being pressed (iOS keyboard does trigger keypress events) and it won't work like the `return` or `enter` key either submitting a form. When pressing this key, it will just blur/unfocus the current element and hide the keyboard.

My advice here is that, if you have a form, you should have an specific `submit` element. If you rely on the user pressing `enter` or `return` keys, that might be counterintuitive for iOS users used to pressing `DONE` when they finish typing.

### Repaint Issues

When you are working with animations, the browsers will try to optimize the repaints to improve performance. We encountered some really specific cases where, for example, an animation happened too quickly outside the viewport and it had the wrong final state.

The solution we had here was to force a repaint of the element at the time we detected it was inside the viewport:

```javascript
afterEnteringTheViewport(element) {
  element.style.transform = 'translateZ(0)'
}
```

> This is just an example of a function, it's not a real callback function you can use like an event handler. How you detect that the element enters the viewport will depend on your app's implementation. You could use the `IntersectionObserver` for example or some css animation-related events.

### Safari can't Handle `box-shadow` and a Gradient Background

If you have an element with both properties, the element won't have the shadow.

You can try opening [this codepen](https://codepen.io/arieljuod/pen/JjGjGEg) using safari on iOS and in other browsers to compare. The first div will have no shadow even if the gradient is as simple as a `white to white` gradient.

If you need a gradient background AND a box shadow in the same element, you may have to create an auxiliary element (or a `:before` pseudo element) absolute positioned behind all the other elements to serve as background. Then you can make that background element have the gradient, and the original element have the box-shadow.

### The Notch

iOS introduced `The Notch` a few years ago. This hardware element will cover a part of the screen. Your mini will be displayed behind the notch, so you'll have to take that into consideration when designing your app, so you don't put elements fixed at the top that might be obscured by the notch.

You can use CSS' safe area inset values to add extra padding when needed.

This is another great article from css-tricks you can use for more in-depth code an examples: [link](https://css-tricks.com/the-notch-and-css/).

If you need to know these values in your JavaScript code, the SDK provides that information (using `sc.app.safeAreaInsets`) with the top and bottom safe area inset values.

### iOS Overscroll

Apple users are used to the extra scroll behavior. When the user reaches the end of something that's scrollable, they can scroll a bit more and a white space shows up in the direction they over-scrolled.

If you want to prevent that overscroll to shift your whole app outside the viewport, you can position your app fixed to the viewport, so if the user overscrolls it, it will scroll to the static element in the background but your app will be fixed on top so the scroll will not affect it. It may be hard to explain, and the code for this is just a `position: fixed` on an element, hopefully this explanation is enough if you are experiencing the same issue.

### Android Keyboard Covers Screen

Android and iOS devices does different things when you open the keyboard. Each of them has pros and cons. One key difference is that when you open the keyboard on iOS, it will try to scroll so the input is inside the viewport and if it can scroll to it it will move the whole app outside the screen if necessary so the input is visible. For Android, it will only try to scroll but if the element is to look inside the viewport, it will be covered by the keyboard. You may need to take this into consideration when designing.

## Conclusion

We were able to fix or workaround a lot of inconsistencies between Chrome for Android and iOS' Safari, and we wanted to share the issues we had and the solutions we've found so far. Some solutions may not have a clear code snippet to apply them, but I hope the explanations are clear enough so you can implement your own solutions when working with minis or mobile webapps.