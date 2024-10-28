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
You may have noticed the `AppSettings` in the previous section. These provide useful information about the app, such as name, version and accentColor. You can use the accent color with `.tint()` (more about this later), but some components, such as NavigationLinks use it by default.

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

## The first button
That's fine already, but you sure want some interactive components like a button in your app. A button looks like this:
<img width="164" alt="Bildschirmfoto 2024-10-18 um 11 16 05" src="https://github.com/user-attachments/assets/2528de99-72ce-44d8-9282-8e85a62697bd">

And is pressed with its assigned key (ctrl+A in the image).

Let's add a button to your app:

```swift
var body: some Renderable {
    ...
    Button(.cA, "Press me!") {
        print("Hooray!")
    }
    ...
}
```

Run the app with `swift run` again and press ctrl+a.

The first argument `.cA` is the key used to press the button if you type `Button(.` in Xcode, you should see some available keys.

> [!TIP]
> Some keys, such as `F1` and `^L` are handled by Interactions and may not work if you bind them to your button.
> Some other keys, such as `^C` and `^Z` are handled by the terminal and are thus not available.

The second argument `"Press me!"` is the label of the button.
The third argument is a closure of type `() -> Void`. It's executed when the button is pressed.

> [!WARNING]
> The example uses `print()` as action for the button, but this function renders the text right away, without being handled by Interaction's app renderer.
> If you want to show a message, use an `Alert` instead (see section "Alerts").

## Scenes
It would be great if you could create multiple scenes and let the user navigate between them, wouldn't it?

1. Add this to your project:
   
```swift
struct SecondScene: Scene {
    let title = "Second scene"

    var body: some Renderable {
        Text("Navigate back with escape")
    }
}
```

2. Add this to your app struct:





```swift
var body: some Renderable {
    ...
    NavigationLink(key: .n1, name: "Press me to navigate", title: "Second scene") {
        SecondScene()
    }
    ...
}
```

3. Restart the app and press the "1" key on your keyboard. You should see:

<img width="682" alt="Bildschirmfoto 2024-10-18 um 11 33 44" src="https://github.com/user-attachments/assets/63a50852-d6cf-4f9f-b6b3-47ccd5ffb837">

4. Press escape to go back to your app's the main screen.

> [!TIP]
> You may need to press escape twice, because the terminal represents the escape key as a strange sequence of multiple bytes. I'm working on it! 🔨

The navigation link is basically just a button in the app's accent color that navigates to the given scene when it's pressed. It has one additional argument: `title` is the title that's shown in the white header bar when the scene is active.

> [!NOTE]
> You may have noticed the `title` prop of your second scene. Unfortunately it's currently not possible yet to display this title in the header. I'm working on it! 🔨

– _to be continued_ –
