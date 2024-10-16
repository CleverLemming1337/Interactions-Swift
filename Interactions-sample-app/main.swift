//
//  main.swift
//  Interactions-sample-app
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation
import Interactions


struct InteractionsSampleApp: App {
    var body: some Renderable {
        HelloWorld()
    }
}

struct HelloWorld: Interaction {
    @Environment(\.logger) var logger
    
    
    var body: some Renderable {
        RawText("Hello, world!")
        Text("Another text")
            .tint(.red)
        Text("This text is bold")
            .bold()
        Button(.cA, "Press me with ^A") {
            print("Button pressed")
        }
        Button(.cB, "Add log message") {
            let log = Log(level: .info, message: "This is an info message")
            logger?.log(log)
        }
        Button(.cD, "Show log") {
            logger?.printLogs()
        }
        Button(.arrowUp, "Try keys") {
            var key = Key.null
            repeat {
                key = readKey()
                print(key.toString(), key.rawValue)
            } while key != .enter
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
