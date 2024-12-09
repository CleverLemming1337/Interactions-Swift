//
//  Menu.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation

public struct MenuOption {
    let name: String
    
    public init(name: String) {
        self.name = name
    }
}
public struct NewNavigationLink: Interaction, Activatable {
    let key: Key?
    let label: String
    let destination: any Renderable
    let title: String
    
    @LegacyEnvironment(\.settings) var settings
    @Environment(\.navigationPath) var navigationPath
    
    public func activate() {
        navigationPath.navigate(to: destination)
    }
    public var body: some Renderable {
        if key != nil {
            Button(key!, label) {
                activate()
            }
            .tint()
        }
        else {
            HStack {
                Text(label)
                    .align(width: AppRenderer.shared.terminalSize.0-6, alignment: .leading)
                Text("❯")
            }
        }
    }
    
    @available(*, deprecated, renamed: "init(key:label:destination:)", message: "Use init(key:label:destination:) instead.")
    public init(key: Key, name: String, title: String = "", @InteractionBuilder _ destination: () -> [Renderable]) {
        self.key = key
        self.label = name
        self.title = title
        self.destination = destination()
    }
    
    public init(key: Key? = nil, label: String, destination: any Scene) {
        self.key = key
        self.label = label
        self.title = destination.title
        self.destination = destination
    }
}
public struct NavigationLink: Interaction, Activatable {
    let key: Key?
    let label: String
    let destination: any Renderable
    let title: String
    
    @LegacyEnvironment(\.settings) var settings
    
    public func activate() {
        AppRenderer.shared.setScene(destination, title: title)
    }
    public var body: some Renderable {
        if key != nil {
            Button(key!, label) {
                activate()
            }
            .tint()
        }
        else {
            HStack {
                Text(label)
                    .align(width: AppRenderer.shared.terminalSize.0-6, alignment: .leading)
                Text("❯")
            }
        }
    }
    
    @available(*, deprecated, renamed: "init(key:label:destination:)", message: "Use init(key:label:destination:) instead.")
    public init(key: Key, name: String, title: String = "", @InteractionBuilder _ destination: () -> [Renderable]) {
        self.key = key
        self.label = name
        self.title = title
        self.destination = destination()
    }
    
    public init(key: Key? = nil, label: String, destination: any Scene) {
        self.key = key
        self.label = label
        self.title = destination.title
        self.destination = destination
    }
}

public class NavigationPath: @unchecked Sendable {
    var elements = [Renderable]()
    
    public func navigate(to destination: Renderable) {
        elements.append(destination)
        AppRenderer.shared.renderApp()
    }
    
    public func back() {
        _ = elements.popLast()
        AppRenderer.shared.renderApp()
    }
    public func displayed() -> Renderable? {
        return elements.last
    }
}
public struct NavigationStack: Interaction, @unchecked Sendable {
    let path = NavigationPath()
    @State private var count = 0
    let content: Renderable
    
    public var body: some Renderable {
        if let displayed = path.displayed() {
            displayed
                .environment(\.accentColor, .red)
                .environment(\.navigationPath, path)
        }
        else {
            content
                .environment(\.accentColor, .red)
                .environment(\.navigationPath, path)
        }
    }
    
    public init(@InteractionBuilder _ content: () -> Renderable) {
        self.content = content()
    }
}

@available(*, deprecated, renamed: "NavigationLink", message: "Use NavigationLink instead")
public struct Navigation: Interaction {
    @LegacyEnvironment(\.keyBinder) var keyBinder
    @LegacyEnvironment(\.renderer) var renderer
    
    let options: [MenuOption]
    public var body: some Renderable {
        for (index, option) in options.prefix(9).enumerated() {
            Button(Key(rawValue: UInt16(index+49)) ?? .null, option.name) {
                renderInteraction {
                    Text("You chose: \(option.name)")
                }
                for index in 0..<options.count {
                    keyBinder.unbind(key: Key(rawValue: UInt16(index+49)) ?? .null)
                }
                renderer.renderApp()
            }
            .tint()
        }
        
    }
    
    public init(options: [MenuOption]) {
        self.options = options
    }
}

