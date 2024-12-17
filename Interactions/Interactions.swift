//
//  Interactions.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

/// This is a protocol for everything that can be shown in the terminal
public protocol Renderable {
    /// Representation of `self` in the terminal
    func render() -> String
}

/// An extended version of `Renderable` that has a body containing `Renderable`s or `Interaction`s
public protocol Interaction: Renderable {
    associatedtype Body: Renderable
    
    /// This property contains the components that are rendered
    @InteractionBuilder var body: Body { get }
}

public extension Interaction {
    /// Renders the `body`
    func render() -> String {
        return self.body.render()
    }
}

/// This result builder is used by the `body` property of `Interaction` and generates one `Renderable` component from many
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
        return components.compactMap { $0 }
    }
    static func buildArray(_ components: [Renderable]) -> Renderable {
        return components.compactMap { $0 }
    }
    static public func buildOptional(_ component: [Renderable]?) -> [Renderable] {
        return component ?? []
    }
        
    static public func buildEither(first component: [Renderable]) -> [Renderable] {
        return component
    }

    static public func buildEither(second component: [Renderable]) -> [Renderable] {
        return component
    }
}

/// Makes an Array of `Renderable`s `Renderable`
extension [Renderable]: Renderable {
    public func render() -> String {
        return Group(components: self).render()
    }
}

/// Helper group to group many `Renderable` into one
public struct Group: Renderable {
    let components: [Renderable]
    
    public func render() -> String {
        return components.map { $0.render() }.joined(separator: "\n")
    }
    
}

/// A scene is a screen or view, which `NavigationLink`s can point to
public protocol Scene: Interaction {
    /// Displayed in the header when the scene is active
    var title: String { get }
}

/// An app is the main component, containing other components and providing settings, like name, version and accent color
public protocol App: Scene {
    /// Called to start the app
    func run()
    /// Contains useful information like name, version and accent color
    var settings: AppSettings { get }
}

public extension App {
    /// Sets up and runs the app.
    /// Enables raw mode, clears the screen, sets the current scene and renders the app.
    /// After that, the pressed keys are read: escape will navigate back one scene, ^L will show the log and all other keys are directed to the `KeyBinder`, which handles the keys bound by buttons or other interactive elements.
    /// When quitting the app, raw mode is disabled.
    func run() {
        print("Initializing app...")
        _ = enableRawMode()
        AppRenderer.shared.hideCursor()
        
        interceptSignals()
        
        AppRenderer.shared.clearScreen()
        AppRenderer.shared.setScene(self)
        AppRenderer.shared.renderApp()
        
        @LegacyEnvironment(\.dismiss) var dismiss
        
        while true {
            let key = readKey()
            if key == .escape {
                dismiss()
            }
            else if key == .cL {
                AppRenderer.shared.setScene(LogList())
            }
            else if key == .arrowUp {
                ScrollController.shared.scroll(-1)
            }
            else if key == .arrowDown {
                ScrollController.shared.scroll()
            }
            else if key == .space {
                ScrollController.shared.scroll(Int(AppRenderer.shared.terminalSize.1)-5)
            }
            else {
                KeyBinder.shared.execute(with: key)
            }
        }
    }
}

/// Provides global information about the app, such as name, version and accent color
public struct AppSettings: Sendable {
    /// Name of the app
    public let name: String
    /// Version of the app
    public let version: String
    /// Accent color of the app. It can be used with `.tint()` on `Formattable`s and some components like NavigationLinks use it by default
    public let accentColor: Color
    
    /// Sets the settings and use default values:
    /// `name` = `"Interactions app"`
    /// `version` = `"0.0.0"`
    /// `accentColor` = `.cyan`
    /// After setting the values, the settings are set in the `EnvironmentProvider` to make them accessible globally through `@Environment`, unless the parameter `set` is `false` (to avoid infinite loops when copying an `AppSettings` instance)
    public init(name: String = "Interactions app", version: String = "0.0.0", accentColor: Color = .cyan, set: Bool = true) {
        self.name = name
        self.version = version
        self.accentColor = accentColor
        
//        if set {
//            EnvironmentProvider.shared.setSettings(self)
//        }
    }
}
