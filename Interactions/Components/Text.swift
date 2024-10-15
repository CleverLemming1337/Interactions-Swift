//
//  Text.swift
//  Interactions
//
//  Created by Leonard on 15.10.24.
//

import Foundation

protocol Formattable: Renderable {
    func bold() -> Self
}

public struct RawText: Renderable {
    public let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public func render() -> String {
        return text
    }
}

public struct Text: Interaction, Formattable {
    
    public let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public func bold() -> Text {
        return Self("\u{001B}[1m\(text)\u{001B}[22m")
    }
    
    public var body: some Renderable {
        RawText(self.text)
    }
}
