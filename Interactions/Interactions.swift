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
    static public func buildBlock(_ components: Renderable...) -> [Renderable] {
        return components
    }
    static public func buildOptional(_ component: Renderable?) -> Renderable {
        return component ?? RawText("")
    }
    static public func buildEither(first component: Renderable) -> Renderable {
        return component
    }

    static public func buildEither(second component: Renderable) -> Renderable {
        return component
    }
}

extension [Renderable]: Renderable {
    public func render() -> String {
        return Group(components: self).render()
    }
}

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
        let original = enableRawMode()
        AppRenderer.shared.clearScreen()
        AppRenderer.shared.setApp(self)
        AppRenderer.shared.renderApp()
        
        while true {
            let key = readKey() // Hier wird die Taste gelesen
            
            if key == 27 { // tab
                AppRenderer.shared.renderApp()
                
                
                
            }
            else if key == 10 { // enter
            }
            print(key)
        }
        
        disableRawMode(original: original)
    }
}

class AppRenderer: @unchecked /* fixes Swift 6 language mode errors */ Sendable {
    static let shared = AppRenderer()
    
    private init() {}
    
    private var app: (any App)?

    func setApp(_ app: (any App)?) {
        self.app = app
    }

    func renderApp() {
        guard let app = app else { return }
        
        if !supportsAnsiCodes() {
            fatalError("Your environmennt does not support ANSI escape sequences which are required to use this app.")
        }
        clearScreen()
        print(app.render())
    }
    func clearScreen() {
        print("\u{001B}[2J\u{001B}[H", terminator: "")
    }
}

public class StateStorage: @unchecked Sendable {
    static let shared = StateStorage()
    public var storage = [UUID: Any]()
}

@propertyWrapper
public struct State<T> {
    let id = UUID()
    
    public init(wrappedValue: T) {
        StateStorage.shared.storage[id] = wrappedValue
    }
    
    public var wrappedValue: T {
        get {
            return StateStorage.shared.storage[id] as! T
        }
        set {
            StateStorage.shared.storage[id] = newValue
            AppRenderer.shared.renderApp()
        }
    }
}
