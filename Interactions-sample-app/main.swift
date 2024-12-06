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
    @State private var count = 0
    @State private var text = ""
    
    let title = "State demo"
    
    @State private var isOn = false

    let data = [("A", "a"), ("B", "b")]
    
    var body: some Renderable {
        VStack {
            ProgressBar(progress: count)
            Text("Counter is at \(count)")
            Button(Key.cA, "Count up") {
                count += 1
            }
            TextField(.n1, "Your name", placeholder: "Enter your name...", text: $text)
            if text != "" {
                Text("Hello, \(text)!")
            }
            else {
                Text("Press 1 to enter your name")
            }
            Toggle(label: "Press 2 to toggle me", key: .n2, isOn: $isOn)
        }
    }
}

struct ScrollDemo: Scene {
    let title = "Scroll demo"
    
    var body: some Renderable {
        Text("Use \(Key.arrowUp.name) and \(Key.arrowDown.name) to scroll.")
        Separator()
        Text("Here’s")
        Text("to")
        Text("the")
        Text("crazy")
        Text("ones.")
        Text("The")
        Text("misfits.")
        Text("The")
        Text("rebels.")
        Text("The")
        Text("troublemakers.")
        Text("The")
        Text("round")
        Text("pegs")
        Text("in")
        Text("the")
        Text("square")
        Text("holes.")
        Text("The")
        Text("ones")
        Text("who")
        Text("see")
        Text("things")
        Text("differently.")
        Text("They’re")
        Text("not")
        Text("fond")
        Text("of")
        Text("rules.")
        Text("And")
        Text("they")
        Text("have")
        Text("no")
        Text("respect")
        Text("for")
        Text("the")
        Text("status")
        Text("quo.")
        Text("You")
        Text("can")
        Text("quote")
        Text("them,")
        Text("disagree")
        Text("with")
        Text("them,")
        Text("glorify")
        Text("or")
        Text("vilify")
        Text("them.")
        Text("But")
        Text("the")
        Text("only")
        Text("thing")
        Text("you")
        Text("can’t")
        Text("do")
        Text("is")
        Text("ignore")
        Text("them.")
        Text("Because")
        Text("they")
        Text("change")
        Text("things.")
        Text("They")
        Text("push")
        Text("the")
        Text("human")
        Text("race")
        Text("forward.")
        Text("And")
        Text("while")
        Text("some")
        Text("may")
        Text("see")
        Text("them")
        Text("as")
        Text("the")
        Text("crazy")
        Text("ones,")
        Text("We")
        Text("see")
        Text("genius.")
        Text("Because")
        Text("the")
        Text("people")
        Text("who")
        Text("are")
        Text("crazy")
        Text("enough")
        Text("to")
        Text("think")
        Text("they")
        Text("can")
        Text("change")
        Text("the")
        Text("world,")
        Text("Are")
        Text("the")
        Text("ones")
        Text("who")
        Text("do.")
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
        Button(.cB, "Add log message") {
            let log = Log(level: .info, message: "This is an info message")
            logger.log(log)
        }
        Button(.cD, "Try keys") {
            print("Press any key, ESC to exit")
            var key = Key.null
            repeat {
                key = readKey()
                print(key.name, key.rawValue)
            } while key != .escape
        }
        Separator()
        NavigationLink(key: .f1, label: "About", destination: About())
        NavigationLink(key: .n1, label: "State demo", destination: Counter())
        NavigationLink(key: .n2, label: "Scroll demo", destination: ScrollDemo())
        Separator()
        NavigationLink(key: .n3, label: "Components", destination: ComponentList())
        NavigationLink(key: .n4, label: "Color", destination: ColorDemo())
    }
}

struct ColorDemo: Scene {
    let title = "Color"

    @State private var r = 0
    @State private var g = 0
    @State private var b = 0

    var body: some Renderable {
        VStack {
            ForEach(Array(0...255), separator: " ") { color in
                Text("\(color)")
                    .tint(.color256(UInt8(color)))
            }
            VStack(spacing: 0) {
                List(.n1, "RGB colors") {
                    Slider(value: $r, in: 0...255, label: "Red:   ")
                    Slider(value: $g, in: 0...255, label: "Green: ")
                    Slider(value: $b, in: 0...255, label: "Blue:  ")
                }
            }
            Text("Red: \(r), Green: \(g), Blue: \(b)")
            Text("   ")
                .background(.rgb(UInt8(r), UInt8(g), UInt8(b)))
        }
    }
}

InteractionsSampleApp().run()
