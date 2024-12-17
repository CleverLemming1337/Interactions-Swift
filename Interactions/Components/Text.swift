//
//  Text.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

public struct RawText: Renderable {
    public let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public func update() -> String {
        render()
    }
    
    public func render() -> String {
        return text
    }
}

public func stripANSICodes(_ text: String) -> String {
    // This regex matches ANSI escape sequences
    let pattern = "\u{001B}\\[.*?m"
    return text.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
}
