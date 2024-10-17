//
//  Overlay.swift
//  Interactions
//
//  Created by Leonard on 17.10.24.
//

import Foundation

public struct Overlay: Interaction {
    public let x: UInt16
    public let y: UInt16
    let content: [Renderable]
    
    public var body: some Renderable {
        for (index, component) in unpackComponents(components: content).enumerated() {
            RawText("\u{1b}[\(Int(y)+index);\(x)H")
            component
        }
    }
    
    public init(x: UInt16, y: UInt16, @InteractionBuilder _ content: () -> [Renderable]) {
        self.x = x
        self.y = y
        self.content = content()
        
    }
    
    func unpackComponents(components: [Renderable]) -> [Renderable] {
        var result = [Renderable]()
        for (index, component) in components.enumerated() {
            if let componentGroup = component as? [Renderable] {
                result.append(contentsOf: unpackComponents(components: componentGroup))
            }
            else {
                result.append(component)
            }
        }
        return result
    }
}

public struct Alert: AbsolutePosition {
    public let x: UInt16
    public let y: UInt16
    let width: UInt16
    let title: String
    let text: String
    let level: LogLevel
    
    public var body: some Renderable {
        Overlay(x: x, y: y) {
            Text("╭\(centered: " "+title+" ", width: width, filling: "─")╮")
                .padding(2)
            Text("│\(String(repeating: " ", count: Int(width)))│")
                .padding(2)
            for line in wrapLinesByWords(text: text, width: width-2).split(separator: "\n") {
                Text("│ \(centered: String(line), width: width-2) │")
                    .padding(2)
            }
            Text("│\(String(repeating: " ", count: Int(width)))│")
                .padding(2)
            Text("╰\(String(repeating: "─", count: Int(width)))╯")
                .padding(2)
        }
    }
    
    public init(title: String, text: String, level: LogLevel) {
        @Environment(\.terminalSize) var terminalSize
        self.x = 5
        self.y = 5
        self.width = terminalSize.0-6
        self.title = title
        self.text = text
        self.level = level
    }
}
