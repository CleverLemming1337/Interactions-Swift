//
//  Interactions.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

public protocol Renderable {
    func render() -> String
}

public protocol Interaction: Renderable {
    associatedtype Body: Renderable
    @InteractionBuilder var body: Body { get }
}

public extension Interaction {
    func render() -> String {
        return self.body.render()
    }
}

@resultBuilder public struct InteractionBuilder {
    static public func buildBlock(_ components: Renderable...) -> Group {
        return Group(components: components)
    }
}

// A helper struct to group multiple Renderables
public struct Group: Renderable {
    let components: [Renderable]
    
    public func render() -> String {
        return components.map { $0.render() }.joined(separator: "\n")
    }
}

public protocol App: Interaction {
    func run()
}

public extension App {
    func run() {
        print("Initializing app...")
        // TODO: Clear screen
        print(self.body.render())
    }
}
