# Tutorial
This tutorial shows you how to build your own Interactions application step by step.

## Setup
1. If you are using Xcode, create a project or target of type "Command line tool".
2. Go to your new target > "Frameworks and Libraries" > "+" > "Add other..." > "Add package dependeny..." and enter `https://github.com/CleverLemming1337/Interactions-Swift.git` as package URL.

## Your first app
1. Write the following code into your `main.swift` file:
```swift
import Foundation
import Interactions

struct MyApp: App {
    let title = "Hello, World!"

    let settings = AppSettings(
        name: "My first Interactions app",
        accentColor: .green
    )

    var body: some Renderable {
        Text("Hello, world!")
    }
}

MyApp().run()
```
2. Open a terminal, go to your target folder and type `swift run`. You may need to create a `Package.swift` file first.
3. You should see something like this:


   <img width="682" alt="Bildschirmfoto 2024-10-18 um 11 08 44" src="https://github.com/user-attachments/assets/0d14828d-2e1d-4ed9-bc2a-e64da430ecd8">

## Settings
You may have noticed the `AppSettings` in the previous section. These provide useful information about the app, such as name, version and accentColor. You can use the accent color with `tint()` (more about this later), but some components, such as NavigationLinks use it by default.

The app title is displayed in the white header line on the start screen.

1. Adjust the app title and settings as you like it.
2. Add the following to change your app version (default is `0.0.0`):
```swift
AppSettings(
    ...
    version: "...",
    ...
)
```
