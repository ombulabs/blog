---
layout: post
title: "What we Learned Developing Snap Minis (Part 1)"
date: 2020-10-23 15:00:00
categories: ["learning"]
author: arieljuod
---

Over the last few months, we developed a couple of [Snap Minis](https://www.ombulabs.com/blog/software-development/snap-minis.html). Minis are small static web apps that are run inside a webview within the Snapchat native app.

One important part of the development was to make sure our Mini works well across different devices, especially making sure things work the same in both Android's webview (Chrome by default) and iOS's webview (Safari).

In this post I'll talk about a few things to keep in mind when working with the Snap Canvas SDK and in the next one I'll talk about some common and known issues you'll encounter when making your app cross-mobile-browser compatible.

<!--more-->

## Working with the SDK

Snapchat provides a JavaScript SDK that you'll have to include in your project. This SDK works as a bridge between the native app and your web app and lets you trigger native functionalities (like sharing on chat and camera), gives you information about the current user and session, and also sends different events so you can react to them (you can detect if a user takes a screenshot or changes the volume for example).

Along with the SDK, Snapchat will provide guides, documentation, a manual and a support website with FAQs and useful information.

### Initializing the SDK

Along with the SDK files, you'll have the documentation and the manual to help you set up the SDK initialization. The process is simple and it's explained in the manual so we won't go over that here. However, one thing to keep in mind is is that the initialization callback won't be triggered outside the native app when you are developing the app on a desktop/laptop computer. If your app depends on the SDK being initialized to work properly, you'll have to implement a fallback mechanism to trigger the same callback locally.

There are many ways to do so: you can use node or webpack to have different code executed in different environments, you can have a boolean flag that you flip manually before compiling the Mini, etc. You can do what works best for your process.

> We recommend always waiting for the SDK initialization before rendering the app to prevent issues.

### Fallback Method Calls when Working Locally

When developing locally, since the SDK won't be connected to a native app, you'll have to handle some fallbacks in the places where you need to call SDK methods (when sharing to camera or chat, for example) if you want to test the app flow more easily instead of publishing every change so you can access the Mini using your phone.

For example, if your app uses the share-to-chat functionality, and you call the SDK method responsible for that locally, it will throw an exception. If you need to respond to that action because, for example, you need to change to a different state, you may need to implement a fallback mechanism. You can `try/catch` the exception for example, or check if `sc.app` is defined or not (in this case, `sc` is the variable containing the SDK instance and the `app` property is an object with information of the native app that won't be populated when running locally).

### Displaying a Sticker when Sharing Content Using the Camera

To share content using the camera, the SDK provides a method that you can call passing a `Sticker`, this is a class defined by the SDK that contains some metadata for the sticker and the content of the actual image file base64-encoded.

Depending on your design and what you want to show as the sticker, you can have the base64 string hardcoded. This may not be the best idea because it will increase the size of your JavaScript code even for users not using that functionality.

For us, a more efficient solution was to use the HTML Canvas Element to draw an image only when required and get the base64 encoded image data. We had to use the full power of the canvas element to draw more things like rendering text, lines, background, etc. Then, after everything was drawn, we could get the base64 data url.

If you need to implement the share-to-camera functionality, it's not easy to test the sticker generation while you are developing it. To help us create the sticker more easily, we used this simple snippet:

```javascript
// `sc` is the snap canvas SDK reference
let base64data = generateStickerData();
if (sc.app) {
  // this method will prepare the sticker object and call the SDK methods
  shareStickerUsingSDK(base64Data);
} else {
  // this will show an IMG element during development locally, so we can see what we created
  previewImage.src = base64data;
}
```

This speeds up the sticker design process a lot, since we don't need to publish the Mini to test it inside Snapchat. After we were happy with the generated image, we started testing the real SDK method calls by publishing the Mini to be used inside Snapchat.

> Consider using high resolution assets for this or it will look pixelated for high pixel density devices.

## Storing Data

Depending on the nature of your Mini, you may need to store some data related to the user's state/actions (you may want to store an ID you get from a service, a timestamp when a user did some action, etc). We needed to store if a user had already done one specific action. For simple data like this, you can use the SDK's provided methods to write and read the local storage. Don't confuse this with the browser's local storage API: the local storage provided by the SDK is similar in some aspects but it has an async nature while the browser's local storage is synchronous.

You can use it to store simple string key/value pairs. You can store small and simple objects by "stringifying" them first, but you shouldn't abuse this.

If you need to store more data, more complex data, or if you need a database to share data between users, you'll need to handle that within your own infrastructure.

## Native Look and Feel

We wanted these Minis to look and feel like native apps. Some key considerations were: the design should not look like a website; sizes, color, animations and transitions should feel similar to what native apps do; and we wanted a scrolling behavior that didn't feel like a website.

For the design, we had an iterative process, the design was changing during development to make it feel more native while we were adding features.

For the scrolling, we wanted to add an inertia and overflow effect like how it works for iOS. We used [this JS plugin](https://github.com/idiotWu/smooth-scrollbar) in specific sections to improve the scrolling experience. You can also implement your custom scrolling behavior using mouse and touch events.

> Make sure you develop a responsive design, your app will run in a broad range of mobile resolutions.

## Performance

One of the apps was animation-intensive: colors changing, text scrolling, different parts could move at the same time, some actions would trigger big changes on the layout, etc.

It was really important to measure and test the performance. The most important tool we used for this was Google Chrome's `Performance` profiler in dev tools. You can profile the app while doing specific actions and then inspect it frame by frame to make sure of what you need to optimize to have smooth animations and transitions.

If you need to use third party plugins, make sure to test how it impacts the performance, sometimes it's better to implement something specific or use a lightweight alternative.

> Remember that your Mini will run in a variety of devices from high to low end, you will want to make sure everyone has a good experience.

## Conclusion

Making a Snapchat Mini is a really interesting project and you are presented to a really big audience. The key things we had to keep in mind were: making sure that it has good performance, that it looks and feels native (and not like a simple website), and that it integrates well with Snapchat's sharing feature to incentivize users to share the Mini with their friends.

The hardest part is to make sure your implementation works well cross-browser. Chrome and Safari behave really differently in some aspects and each of them has their own known bugs and features that you have to take into account. We'll talk about some of those issues on the next part of this series.
