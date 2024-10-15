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
        RawText("Another text")
        Text("This text is bold")
            .bold()
    }
}

InteractionsSampleApp().run()
