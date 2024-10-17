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
    static func buildArray(_ components: [[Renderable]]) -> [Renderable] {
        return components.flatMap { $0 }
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

public protocol Scene: Interaction {
    var title: String { get }
}

public protocol App: Scene {
    func run()
    var settings: AppSettings { get }
}

public extension App {
    func run() {
        print("Initializing app...")
        let original = enableRawMode()
        AppRenderer.shared.clearScreen()
        AppRenderer.shared.setScene(self)
        AppRenderer.shared.renderApp()
        
        @Environment(\.dismiss) var dismiss
        
        while true {
            let key = readKey() // Hier wird die Taste gelesen
            if key == .escape {
                dismiss()
            }
            else if key == .cL {
                AppRenderer.shared.setScene(LogList())
            }
            else {
                KeyBinder.shared.execute(with: key)
            }
        }
        
        disableRawMode(original: original)
    }
}

public struct AppSettings {
    public let name: String
    public let version: String
    public let accentColor: Color
    
    public init(name: String = "Interactions app", version: String = "0.0.0", accentColor: Color = .cyan, set: Bool = true) {
        self.name = name
        self.version = version
        self.accentColor = accentColor
        
        if set {
            EnvironmentProvider.shared.setSettings(self)
        }
    }
}



public class StateStorage: @unchecked Sendable {
    static let shared = StateStorage()
    public var storage = [UUID: Any]()
}
