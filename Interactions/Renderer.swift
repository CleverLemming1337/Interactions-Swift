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
    mutating func appendInterpolation(centered text: String, width: UInt16, filling: Character = " ") {
        let padding = max(0, Int(width) - text.count)
        let leftPadding = padding / 2
        let rightPadding = padding - leftPadding

        let centeredText = String(repeating: filling, count: leftPadding) + text + String(repeating: filling, count: rightPadding)
        appendLiteral(centeredText)
    }
    mutating func appendInterpolation(_ text: String, width: UInt16) {
        let paddingR = max(0, Int(width) - text.count)
        
        appendLiteral(text+String(repeating: " ", count: paddingR))
    }
}

public class AppRenderer: @unchecked /* fixes Swift 6 language mode errors */ Sendable {
    static let shared = AppRenderer()
    
    private init() {}
    
    private var navigationPath = [(String, any Renderable)]()

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
        let sceneTitle = (scene as? any Scene)?.title
        navigationPath.append((sceneTitle ?? title, scene))
        renderApp()
    }

    func renderApp() {
        guard let scene = navigationPath.last?.1 else { return }
        
        if !supportsAnsiCodes() {
            fatalError("Your environmennt does not support ANSI escape sequences which are required to use this app. If you are running this app in Xcode, try `swift run` from a terminal.")
        }
        clearScreen()
        print("\n\n")
        print(scene.render())
        showTitle()
        showSubHeader()
    }
    func clearScreen() {
        print("\u{001B}[2J\u{001B}[H", terminator: "")
    }
    func showTitle() {
        let title = navigationPath.last?.0 ?? ""
        print("\u{001B}7\u{001B}[H\u{001B}[7m\(navigationPath.count > 1 ? " < ESC" : "")\(centered: title, width: terminalSize.0-(navigationPath.count > 1 ? 12 : 0))\(navigationPath.count > 1 ? "      " : "")\u{1b}[27m\u{1b}8")
    }
    func showSubHeader() {
        print("\("\u{1b}7\u{1b}[2;0H\u{1b}[100m \u{1b}[1m^L\u{1b}[22m Show log    \u{1b}[1mF1\u{1b}[22m Help    \u{1b}[1m^X\u{1b}[22m Exit", width: terminalSize.0+41)\u{1b}[0m\u{1b}8")
        return
    }
    func back() {
        _ = navigationPath.popLast()
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
