//
//  Renderer.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation

#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#else
#error("Unknown OS")
#endif

extension String.StringInterpolation {
    mutating func appendInterpolation(_ text: String, width: UInt16, alignment: Alignment = .center, filling: Character = " ") {
        let padding = max(0, Int(width) - text.count)
        let leftPadding = padding / 2
        let rightPadding = padding - leftPadding

        let centeredText: String = {
            switch alignment {
                case .center:
                    return String(repeating: filling, count: leftPadding) + text + String(repeating: filling, count: rightPadding)
                case .leading:
                    return text + String(repeating: filling, count: padding)
                case .trailing:
                    return String(repeating: filling, count: padding) + text
            }
        }()

        appendLiteral(centeredText)
    }
}

public class AppRenderer: @unchecked /* fixes Swift 6 language mode errors */ Sendable {
    static let shared = AppRenderer()
    
    private init() {}
    
    private var navigationPath = [any Renderable]()

    var terminalSize: (UInt16, UInt16) {
        get {
            var w = winsize()
            #if os(macOS)
            if ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 {
                return (w.ws_col, w.ws_row)
            }
            #elseif os(Linux)
            if ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &w) == 0 {
                return (w.ws_col, w.ws_row)
            }
            #endif
            return (0, 0)
        }
    }
    
    func setScene(_ scene: (any Renderable), title: String = "") {
        KeyBinder.shared.unbindAll()
        navigationPath.append(scene)
        ScrollController.shared.scrollIndex = 0
        renderApp()
    }

    func switchScene(to scene: any Renderable) {
        _ = navigationPath.popLast()
        setScene(scene)
    }
    
    func renderApp() {
        guard let scene = navigationPath.last else { return }
        
        if !supportsAnsiCodes() {
            fatalError("Your environmennt does not support ANSI escape sequences which are required to use this app. If you are running this app in Xcode, try `swift run` from a terminal.")
        }
        clearScreen()
        showTitle()
        showSubHeader()
        print("\n", terminator: "")
        print(ScrollController.shared.renderWithScroll(text: scene.render()))
        
    }
    func clearScreen() {
        print("\u{001B}[2J\u{001B}[H", terminator: "")
    }
    func showTitle() {
        let title = (navigationPath.last as? any Scene)?.title ?? ""
        
        var width = terminalSize.0-1
        var header = "\u{001B}7\u{001B}[H\u{001B}[7m "
        var backButton = ""
        if navigationPath.count > 1 {
            if let backTitle = (navigationPath[navigationPath.count-2] as? any Scene)?.title {
                backButton += "< \(backTitle)"
            }
            else {
                backButton = "<"
            }
        }
        header += backButton
        width -= UInt16(2*backButton.count)
        
        header += "\(title, width: width, alignment: .center)"
        header += String(repeating: " ", count: backButton.count)
        header += "\u{1b}[27m\u{1b}8"
        print(header)
    }
    func showSubHeader() {
        print("\("\u{1b}7\u{1b}[2;0H\u{1b}[100m \u{1b}[1m^L\u{1b}[22m Show log    \u{1b}[1mF1\u{1b}[22m Help    \u{1b}[1m^C\u{1b}[22m Exit", width: terminalSize.0+41, alignment: .leading)\u{1b}[0m\u{1b}8")
        return
    }
    func back() {
        _ = navigationPath.popLast()
        ScrollController.shared.scrollIndex = 0
        renderApp()
    }
    func moveCursor(to position: (row: UInt16, col: UInt16)) {
        print("\u{1b}[\(position.col);\(position.row)H", terminator: "")
    }
    func hideCursor() {
        print("\u{1b}[?25l", terminator: "")

        // not working with Glibc
        #if os(macOS)
        fflush(stdout)
        #endif
    }
    func showCursor() {
        print("\u{1b}[?25h", terminator: "")

        // not working with Glibc
        #if os(macOS)
        fflush(stdout)
        #endif
    }
}

public func renderInteraction(@InteractionBuilder _ components: () -> [Renderable]) {
    print(components().render())
}

public class ScrollController: @unchecked Sendable {
    static let shared = ScrollController()
    
    var scrollIndex = 0
    
    func scroll(_ lines: Int = 1) {
        if scrollIndex+lines < 0 {
            scrollIndex = 0
            return
        }
        scrollIndex += lines
        
        AppRenderer.shared.renderApp()
    }
    
    func renderWithScroll(text: String) -> String {
        let lines = text.split(separator: "\n")
        
        if lines.count < AppRenderer.shared.terminalSize.1-3 { // Content to short to be scrolled
            scrollIndex = 0 // prevent bouncing down when a state rendered item is revealed
            return lines.joined(separator: "\n")
        }
        
        if scrollIndex >= lines.count {
            scrollIndex = lines.count - 1
        }
        let endIndex = Int(AppRenderer.shared.terminalSize.1)+scrollIndex-5 < lines.count ? Int(AppRenderer.shared.terminalSize.1)+scrollIndex-5 : lines.count - 1
        
        return lines[scrollIndex...endIndex].joined(separator: "\n")
    }
}
