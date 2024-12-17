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

public func stripANSICodes(_ text: String) -> String {
    // This regex matches ANSI escape sequences
    let pattern = "\u{001B}\\[.*?m"
    return text.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
}

public extension Formattable {
    func bold() -> Formattable {
        return Text("\u{001B}[1m\(self.render())\u{001B}[22m")
    }
    func reversed() -> Formattable {
        return Text("\u{001B}[7m\(self.render())\u{001B}[27m")
    }
    func tint(_ color: Color? = nil) -> Formattable {
        @Environment(\.accentColor) var accentColor
        return Text("\u{001B}[3\(color?.value ?? accentColor.value)m\(self.render())\u{001B}[39m")
    }
    func background(_ color: Color) -> Formattable {
        return Text("\u{001B}[4\(color.value)m\(self.render())\u{001B}[49m")
    }
    func padding(_ x: UInt = 1, width: UInt16? = nil) -> Formattable {
        return padding(left: Int(x), right: Int(x), width: width)
    }
    func padding(left: Int, right: Int = 1, width originalWidth: UInt16? = nil) -> Formattable {
        let width = Int((originalWidth ?? AppRenderer.shared.terminalSize.0)) - left - right
        var lines = [String]()
        for line in wrapLinesByWords(text: self.render(), width: UInt16(width)).split(separator: "\n") {
            lines.append("\(String(repeating: " ", count: left))\(line)\(String(repeating: " ", count: right))")
        }
        
        return Text(lines.joined(separator: "\n"))
    }
    func dark() -> Formattable {
        return Text("\u{001B}[2m\(self.render())\u{001B}[22m")
    }
    func other(_ start: String, end: String = "[0m") -> Formattable {
        return Text("\u{001B}\(start)\(self.render())\u{001B}\(end)")
    }
    func centered(width: UInt16) -> Formattable {
        return Text("\(self.render(), width: width)")
    }
    func underlined() -> Formattable {
        return Text("\u{1b}[4m\(self.render())\u{1b}[24m")
    }
    func align(width inputWidth: UInt16? = nil, alignment: Alignment = .center, filling: Character = " ", padding includedPadding: Int = 0, excludedPadding: Int = 0) -> Formattable {
        /*
        ··Text··········
          |--| Text
         |------------| width
         -    - Included padding
        -              - Excluded padding
        */
        let width = inputWidth ?? AppRenderer.shared.terminalSize.0
        let text = self.render()
        let length = stripANSICodes(text).count
        let completePadding = max(0, Int(width) - length - includedPadding*2)
        let leftPadding = completePadding / 2
        let rightPadding = completePadding - leftPadding

        let centeredText: String = {
            switch alignment {
                case .center:
                    return String(repeating: filling, count: leftPadding) + text + String(repeating: filling, count: rightPadding)
                case .leading:
                    return text + String(repeating: filling, count: completePadding)
                case .trailing:
                    return String(repeating: filling, count: completePadding) + text
            }
        }()
        
        return Text(String(repeating: " ", count: includedPadding+excludedPadding)+centeredText+String(repeating: " ", count: includedPadding+excludedPadding))
    }
}

public enum Color: Sendable {
    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case normal
    case color256(_ number: UInt8)
    case rgb(_ red: UInt8, _ green: UInt8, _ blue: UInt8)
    
    /// Returns the ANSI value of the color as string
    /// Example: red is `\u{1b}[31m`
    /// `.red` would return `"1"` (part between `3` and `m`
    var value: String {
        get {
            switch self {
            case .black: return "0"
            case .red: return "1"
            case .green: return "2"
            case .yellow: return "3"
            case .blue: return "4"
            case .magenta: return "5"
            case .cyan: return "6"
            case .white: return "7"
            case .normal: return "9"
            case let .color256(number): return "8;5;\(number)"
            case let .rgb(r, g, b): return "8;2;\(r);\(g);\(b)"
            }
        }
    }
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
        self.elements = unpackComponents(components: content())
        self.spacing = spacing
    }
}

public struct VStack: Interaction, Formattable {
    let elements: [Renderable]
    let spacing: Int
    
    public var body: some Renderable {
        var result = ""
        for (index, element) in elements.enumerated() {
            result += element.render() + "\n"
            if index < elements.count - 1 {
                result += Separator(spacing).render()
            }
        }
        return RawText(result)
    }
    
    public init(spacing: Int = 1, @InteractionBuilder _ content: () -> [Renderable]) {
        self.elements = content()
        self.spacing = spacing
    }
}

public struct Separator: Interaction {
    let lines: Int
    
    public init(_ lines: Int = 1) {
        self.lines = lines
    }
    
    public var body: some Renderable {
        RawText(String(repeating: " \u{0} \n", count: lines))
    }
}

func unpackComponents(components: [Renderable]) -> [Renderable] {
    var result = [Renderable]()
    for component in components {
        if let componentGroup = component as? [Renderable] {
            result.append(contentsOf: unpackComponents(components: componentGroup))
        }
        else {
            result.append(component)
        }
    }
    return result
}

func wrapLine(line: String, width: UInt16) -> [String] {
    if line.trimmingCharacters(in: .whitespacesAndNewlines).count <= width {
        return [line.trimmingCharacters(in: .whitespacesAndNewlines)]
    }
    var lines = [String]()
    lines.append(String(line.prefix(Int(width))))
    lines.append(contentsOf: wrapLine(line: String(line.suffix(line.count-Int(width))), width: width))
    
    return lines
}

public func wrapLines(text: String, width: UInt16) -> String {
    let lines = text.split(separator: "\n")
    var result = [String]()
    
    for line in lines {
        result.append(contentsOf: wrapLine(line: String(line), width: width))
    }
    return result.joined(separator: "\n")
}

func wrapLineByWords(line: String, width: UInt16) -> [String] {
    if line.trimmingCharacters(in: .whitespaces).count < width {
        return [line.trimmingCharacters(in: .whitespacesAndNewlines)]
    }
    
    let words = line.split(separator: " ")
    var result = [String]()
    var newLine = ""
    for word in words {
        if newLine == "" {
            newLine = String(word)
            continue
        }
        if word.count > width {
            result.append(contentsOf: wrapLine(line: String(word), width: width))
            continue
        }
        if (newLine+" "+word).count > width {
            result.append(newLine)
            newLine = String(word)
            continue
        }
        newLine += " "+word
    }
    result.append(newLine)
    return result
}

public func wrapLinesByWords(text: String, width: UInt16) -> String {
    let lines = text.split(separator: "\n")
    var result = [String]()
    
    for line in lines {
        result.append(contentsOf: wrapLineByWords(line: String(line), width: width))
    }
    
    return result.joined(separator: "\n")
}

public enum Alignment {
    case leading
    case center
    case trailing
}
