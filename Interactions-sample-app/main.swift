//
//  main.swift
//  Interactions-sample-app
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation
import Interactions


struct InteractionsSampleApp: App {
    var title = "Welcome!"
    
    let settings = AppSettings(
        name: "Interactions Sample App",
        accentColor: .cyan
    )
    
    var body: some Renderable {
        HelloWorld()
    }
}

struct About: Scene {
    @Environment(\.settings) var settings
    
    let title = "About this app"
    
    var body: some Renderable {
        Text("Version \(settings.version)")
        Alert(title: "Test", text: "That’s pretty cool, but where key paths really start to shine is when they’re used to form slightly more complex expressions, such as when sorting a sequence of values.", level: .info)
    }
}

struct Counter: Scene {
    let count = StateItem(0)
    
    let title = "State demo"
    
    var body: some Renderable {
        Text("Counter is at \(count.value)")
        Button(Key.cA, "Count up") {
            count.value += 1
        }
    }
}

struct HelloWorld: Interaction {
    @Environment(\.logger) var logger
    @Environment(\.terminalSize) var terminalSize
    @Environment(\.settings) var settings
    
    var body: some Renderable {
        RawText("Hello, world!")
        Text("Another text")
            .tint(.red)
        Text("This text is bold")
            .bold()
        Text("This text is in the app's accent color")
            .tint()
        Button(.cA, "Press me with ^A") {
            print("Button pressed")
        }
        Button(.cB, "Add log message") {
            let log = Log(level: .info, message: "This is an info message")
            logger.log(log)
        }
        Button(.arrowUp, "Try keys") {
            var key = Key.null
            repeat {
                key = readKey()
                print(key.toString(), key.rawValue)
            } while key != .enter
        }
        NavigationLink(key: .f1, name: "About", title: "About this app") {
            About()
        }
        NavigationLink(key: .n1, name: "State demo") {
            Counter()
        }
    }
}



struct MyComponent: Interaction {
    private var state = StateItem(0)
    
    var body: some Renderable {
        Text(String(state.value))
    }
}



InteractionsSampleApp().run()
