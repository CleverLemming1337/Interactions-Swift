//
//  Menu.swift
//  Interactions
//
//  Created by Leonard on 16.10.24.
//

import Foundation

public struct MenuOption {
    let name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct NavigationLink: Interaction {
    let key: Key
    let name: String
    
    @Environment(\.renderer) var renderer
    @Environment(\.settings) var settings
    
    public var body: some Renderable {
        Button(key, name) {
            renderInteraction {
                Text("Navigationlink") // TODO: Set new scene
            }
            renderer.renderApp()
        }
        .tint(settings.accentColor)
    }
    
    public init(key: Key, name: String) {
        self.key = key
        self.name = name
    }
}
public struct Navigation: Interaction {
    @Environment(\.keyBinder) var keyBinder
    @Environment(\.renderer) var renderer
    
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
            .tint(.cyan)
        }
        
    }
    
    public init(options: [MenuOption]) {
        self.options = options
    }
}

