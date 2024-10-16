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
    var body: some Renderable {
        RawText("Hello, world!")
        Text("Another text")
            .tint(.red)
        Text("This text is bold")
            .bold()
        Button(.cA, "Button") {
            print("Hello")
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
