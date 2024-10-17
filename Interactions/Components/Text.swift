//
//  Text.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

public protocol Formattable: Renderable {
}

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

public extension Formattable {
    func bold() -> Formattable {
        return Text("\u{001B}[1m\(self.render())\u{001B}[22m")
    }
    func reversed() -> Formattable {
        return Text("\u{001B}[7m\(self.render())\u{001B}[27m")
    }
    func tint(_ color: Color = EnvironmentProvider.shared.settings.accentColor) -> Formattable {
        return Text("\u{001B}[3\(color.rawValue)m\(self.render())\u{001B}[39m")
    }
    func background(_ color: Color) -> Formattable {
        return Text("\u{001B}[4\(color.rawValue)m\(self.render())\u{001B}[49m")
    }
    func padding(_ x: UInt = 1, _ y: UInt = 0) -> Formattable {
        return Text("\(String(repeating: " ", count: Int(x)))\(self.render())\(String(repeating: " ", count: Int(x)))")
    }
    func dark() -> Formattable {
        return Text("\u{001B}[2m\(self.render())\u{001B}[22m")
    }
    func other(_ start: String, end: String = "[0m") -> Formattable {
        return Text("\u{001B}\(start)\(self.render())\u{001B}\(end)")
    }
}

public enum Color: UInt8 {
    case black = 0
    case red = 1
    case green = 2
    case yellow = 3
    case blue = 4
    case magenta = 5
    case cyan = 6
    case white = 7
}

public struct Text: Interaction, Formattable {
    
    public let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some Renderable {
        RawText(self.text)
    }
}

public struct HStack: Interaction, Formattable {
    let elements: [Renderable]
    let spacing: Int

    public var body: some Renderable {
        var result = ""
        for (index, element) in elements.enumerated() {
            result += element.render()
            if index < elements.count - 1 {
                result += String(repeating: " ", count: spacing)
            }
        }
        return RawText(result)
    }

    public init(spacing: Int = 1, @InteractionBuilder _ content: () -> [Renderable]) {
        self.elements = content()
        self.spacing = spacing
    }
}
