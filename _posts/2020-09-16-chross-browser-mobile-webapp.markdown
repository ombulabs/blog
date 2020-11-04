---
layout: post
title: "Cross-Browser Mobile web apps (Snap Minis Part 2)"
date: 2020-11-05 12:00:00
categories: ["learning", "crossbrowser"]
author: arieljuod
---

Following [the first part of this series](https://www.ombulabs.com/blog/learning/creating-a-snapchat-mini.html), I'll list a few interesting issues we found when making the apps work as similar as possible for Android's webview and iOS' webview.

<!--more-->

## Snap Minis

Some of these issues are related to mobile web development in general, it's not something specific to Snap Minis but Snapchat uses the native webview components to display your Mini. Since you'll want your Mini to work properly for all users you'll have to make fixes for specific issues you may encounter for each webview implementation.

Android uses Chrome by default for the webview, but it is different than desktop Chrome. iOS uses Safari for the webview, but it is also different than desktop Safari. Keep in mind you can fix some of the issues using desktop browsers but you'll have to test them in the mobile browsers to be sure.

### Keypress/release/up/down Events are not Triggered for Mobile Chrome

When you type using Android's default keyboard app, it won't trigger the usual key-related events (`keypress`, `keyup`, etc). Depending on your needs, you may be able to workaround this limitation using an event listener for the `input` or the `change` events.

### MAXLENGTH Attribute won't Work on Mobile Chrome

If you have an input where you want to limit the value's length, the simplest way to do that is to use the input's `maxlength` HTML attribute. That will limit the length disallowing the user to type more characters than expected. But, when typing on an Android device, it won't respect that limit.

The first idea would be to use the `keypress` event and prevent its default behavior depending on the pressed key and the element's value length, but, since we can't relay on the `keypress` event, we had to implement another workaround using the `input` event:

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

If you use an non-input element with the `contenteditable` attribute, you may need to do some changes to that snippet in order to get the current cursor position from the document element.

### Changing Input Case Breaks iOS Keyboard Suggestions

One initial requirement we had for an input element was that it should always show uppercase characters. The easiest solution for this requirement would be to use a CSS text transform property:

```css
#my-input {
  text-transform: uppercase;
}
```

But this creates an issue. This modifies the element's value on iOS and the keyboard app loses track of the original word it has to replace when you select one of the suggestions, not being able to actually apply the suggestion.

We also tried a different solution for that requirement listening to the `input` event and upcasing the letters after the input changed, but this creates the same issue for iOS' keyboard suggestions.

> We would advise not to have that requirement unless it's critical to your app or if you don't mind having the keyboard suggestions functionality broken on that input for iOS.

### DONE Key on iOS is not a Key

iOS keyboard shows a `DONE` "key" as a part of the keyboard, but this does not work like a regular key: you can't detect it being pressed (iOS keyboard does trigger keypress events) and it won't work like the `return` or `enter` key to submit the form. When pressing this special key, it will blur/unfocus the current element and hide the keyboard.

Our advice here is that, if you have a form, you should have an specific `submit` element. If you rely on the user pressing `enter` or `return` keys, that might be counterintuitive for iOS users used to pressing `DONE` when they finish typing.

### Repaint Issues

When you are working with animations, the browsers will try to optimize the repaints to improve performance. We encountered some really specific cases where, for example, an animation happened too quickly outside the viewport and it had the wrong final state.

The solution we had here was to force a repaint of the element at the time we detected it was inside the viewport:

```javascript
afterEnteringTheViewport(element) {
  element.style.transform = 'translateZ(0)'
}
```

> This is just an example of a function, it's not a real callback function you can use like an event handler. How you detect that the element enters the viewport will depend on your app's implementation. You could use the `IntersectionObserver` for example or some css animation-related events.

### Safari Paused CSS Animations

A bit related to the previous one, sometimes iOS won't start CSS animations even if the CSS is present. That might be related to that repaint issue, but the previous solution didn't work for that case. For this one, we added a paused animation for the element and a little delay using javascript to change the css property to start the animation.

### Safari can't Handle `box-shadow` and a Gradient Background

If you have an element with both properties, the element won't display the shadow.

You can try it opening [this codepen](https://codepen.io/arieljuod/pen/JjGjGEg) using Safari on iOS and in other browsers to compare. The first div will have no shadow even if the gradient is as simple as a `white to white` gradient.

If you need a gradient background AND a box shadow in the same element, you may have to create an auxiliary element (or a `:before` pseudo element) absolute positioned behind all the other elements to serve as background. Then you can make that background element have the gradient, and the original element have the box-shadow.

### The Notch

iOS introduced `The Notch` a few years ago. This hardware element will cover a part of the screen. Your mini will be displayed behind the notch, so you'll have to take that into consideration when designing your app, so you don't put elements fixed at the top that might be obscured by the notch.

You can use CSS' safe area inset values to add extra padding when needed.

If you need to know these values in your JavaScript code, the SDK provides that information (using `sc.app.safeAreaInsets`) with the top and bottom safe area inset values.

> This is another great article from css-tricks you can use for more in-depth code an examples: [link](https://css-tricks.com/the-notch-and-css/).

### iOS Overscroll

Apple users are used to the extra scroll behavior. When the user reaches the end of something that's scrollable, they can scroll a bit more and a white space shows up in the opposite direction they over-scrolled.

If you want to prevent that overscroll to shift your whole app outside the viewport, you can position your app fixed to the viewport, so if the user overscrolls it, it will scroll to the static element in the background but your app will be fixed on top so the scroll will not affect it. It may be hard to explain, and the code for this is just a `position: fixed` on an element, hopefully this explanation is enough if you are experiencing the same issue.

### Android Keyboard Covers Screen

Android and iOS devices does different things when you open the keyboard. Each of them has pros and cons.

One key difference is that, when you open the keyboard on iOS, it will try to scroll the page so the input is inside the viewport and if it can scroll to it it will move the whole viewport outside the screen if necessary so the input is visible.

For Android, it will only try to scroll but if the element is to look inside the viewport, it will be covered by the keyboard. You may need to take this into consideration when designing and the SDK provides an event to detect when the keyboard was opened or closed so you can react to that and make sure your input is visible.

### Safari can't do Smooth Scroll

Safari doesn't support the value `smooth` for the [scroll-behavior](https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior) property. It also doesn't support the `behavior: 'smooth'` option for the `Window.scrollTo` function.

If you need smooth scrolling you may use [a polyfill](https://www.npmjs.com/package/smoothscroll-polyfill) or implement another custom scroll mechanism.

## Conclusion

Making sure your app behaves similarly on both platforms is important to provide a good user experience. Sometimes it might be hard to reproduce the issues and to test the app in enough devices to debug them, so we hope some of this tips can help you fix them more easily.

> A good resources you can check for cross browser compatibility is https://caniuse.com/
