//
//  main.swift
//  Interactions-sample-app
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation
import Interactions


struct InteractionsSampleApp: App {
    let title = "Welcome!"
    
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
        
    }
}

struct Counter: Scene {
    let count = StateItem(0)
    let text = StateItem("")
    
    let title = "State demo"
    
    var body: some Renderable {
        VStack {
            Text("Counter is at \(count.value)")
            Button(Key.cA, "Count up") {
                count.value += 1
            }
            TextField(.n1, "Your name", placeholder: "Enter your name...", text: text)
            if text.value != "" {
                Text("Hello, \(text.value)!")
            }
            else {
                Text("Press 1 to enter your name")
            }
        }
    }
}

struct AlertDemo: Scene {
    let title = "Alert demo"
    let showAlert = StateItem(false)
    var body: some Renderable {
        Button(.cD, "Show alert") {
            showAlert.value = true
        }
        Text("\nThis text will be behind the alert.")
        Alert(title: "Alert title", text: "Here’s to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. But the only thing you can’t do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, We see genius. Because the people who are crazy enough to think they can change the world, Are the ones who do.", level: .info, isPresented: showAlert)
        
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
                print(key.name, key.rawValue)
            } while key != .newLine
        }
        NavigationLink(key: .f1, name: "About", title: "About this app") {
            About()
        }
        NavigationLink(key: .n1, name: "State demo") {
            Counter()
        }
        NavigationLink(key: .n2, name: "Alert demo", title: "Alert demo") {
            AlertDemo()
        }
        
    }
}



struct MyComponent: Interaction {
    private var state = StateItem(0)
    
    var body: some Renderable {
        Text(String(state.value))
    }
}



struct MyApp: App {
    let title = "Hello, World!"

    let settings = AppSettings(
        name: "My first Interactions app",
        accentColor: .green
    )

    var body: some Renderable {
        Text("Hello, world!")
        Button(.cA, "Press me!") {
            print("Hurray!")
        }
        NavigationLink(key: .n1, name: "Press me to navigate", title: "Second scene") {
            SecondScene()
        }
    }
}

struct SecondScene: Scene {
    let title = "Second scene"

    var body: some Renderable {
        SwiftLogo()
    }
}

InteractionsSampleApp().run()
