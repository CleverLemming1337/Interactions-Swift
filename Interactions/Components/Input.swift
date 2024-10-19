//
//  Input.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

public struct Button: Interaction, Formattable {
    let key: Key
    let label: String
    let action: () -> Void
    let showShortcut: Bool
    
    public init(_ key: Key, _ label: String, showShortcut: Bool = true, _ action: @escaping () -> Void) {
        self.key = key
        self.label = label
        self.action = action
        self.showShortcut = showShortcut
        
        @Environment(\.keyBinder) var keyBinder
        
        keyBinder.bind(with: key, to: action)
    }
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            if showShortcut {
                Text(key.name)
                    .padding()
                    .other("[100m", end: "[49m")
            }
            Text("\(label)")
                .padding()
                .reversed()
        }
    }
    
}

public struct TextField: Interaction, Formattable {
    
    let key: Key
    let label: String
    let placeholder: String
    let showShortcut: Bool
    let text: StateItem<String>
    
    @Environment(\.renderer) var renderer
    
    public func focus() {
        renderer.showCursor()
        var pressedKey = Key.null
        while pressedKey != .newLine {
            pressedKey = readKey()
            if pressedKey == .backspace {
                _ = text.value.popLast()
            }
            else if pressedKey != .newLine && pressedKey != .carriageReturn{
                text.value += pressedKey.string
            }
        }
        renderer.hideCursor()
    }
    
    public init(_ key: Key, _ label: String, placeholder: String, text: StateItem<String>, showShortcut: Bool = true) {
        self.key = key
        self.label = label
        self.placeholder = placeholder
        self.showShortcut = showShortcut
        self.text = text
        
        @Environment(\.keyBinder) var keyBinder
        
        keyBinder.bind(with: key, to: focus)
    }
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            Text(label)
                .padding()
                .reversed()
            if showShortcut {
                Text(key.name)
                    .padding()
                    .other("[100m", end: "[49m")
            }
            if text.value.count > 0 {
                Text(text.value)
                    .padding()
                    .reversed()
                    .tint()
            }
            else {
                Text(placeholder)
                    .padding()
                    .dark()
                    .reversed()
                    .tint()
            }
            
        }
    }
}
