#  MacOS + The Elm Architecture proof of concept

This project contains a simple macOS application that shows some artists data, as a proof of concept of using ideas from [The Elm Architecture](https://guide.elm-lang.org/architecture/) for macOS app development.

Data is loaded asynchronously, in a paginated way and with an option to retry in case of failure.

![Demo](./Demo.gif)

## Requirements

I have developed it using macOS Ventura 13.1 and Xcode 14.2.

## Details

A small UI framework has been developed under [ArtistView/Architecture](./ArtistView/Architecture), in where `State` management is pure. Then, each UI component under [ArtistView/Architecture](./ArtistView/UI) provides a `State` pure part and a `View` impure that uses `AppKit` programmatically to render and update with a given `State`.

Note that this is just a naive proof of concept implementation. That is why, instead of providing a Virtual DOM, the code for rendering the UI is impure and inefficient. Also, the `Command` implementation details are not hidden to the `View` part, so it could pass any `Message` to the `State` without restriction while the `Message` type is the right one.

## Possible UI testing strategies

* As updating a `State` with a `Message` is pure, and this is in fact the only way allowed to mutate the `State`, Property Based Testing could be applied for generating random `Message`'s and `State`'s, perform updates and test for properties to hold, as in [this Elm package](https://package.elm-lang.org/packages/Janiczek/architecture-test/latest/).
* `View`'s, although impure, could be initialised and then checked regarding its `AppKit` properties and subviews when they are told to render a given randomly generated `State`.
