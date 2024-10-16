//
//  Renderer.swift
//  Interactions
//
//  Created by Leonard on 16.10.24.
//

import Foundation
import Darwin

extension String.StringInterpolation {
    mutating func appendInterpolation(centered text: String, width: UInt16) {
        let padding = max(0, Int(width) - text.count)
        let leftPadding = padding / 2
        let rightPadding = padding - leftPadding

        let centeredText = String(repeating: " ", count: leftPadding) + text + String(repeating: " ", count: rightPadding)
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
            if ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 {
                return (w.ws_row, w.ws_col)
            }
            return (0, 0)
        }
    }
    
    func setScene(_ scene: (any Renderable)) {
        navigationPath.append(scene)
        renderApp()
    }

    func renderApp() {
        guard let scene = navigationPath.last else { return }
        
        if !supportsAnsiCodes() {
            fatalError("Your environmennt does not support ANSI escape sequences which are required to use this app. If you are running this app in Xcode, try `swift run` from a terminal.")
        }
        clearScreen()
        print("\n")
        print(scene.render())
        showTitle()
    }
    func clearScreen() {
        print("\u{001B}[2J\u{001B}[H", terminator: "")
    }
    func showTitle() {
        let title = (navigationPath.last as? (any Scene))?.title
        print("\u{001B}7\u{001B}[H\u{001B}[7m\(centered: title ?? "", width: terminalSize.1)\u{1b}[27m\u{1b}8")
    }
    func back() {
        _ = navigationPath.popLast()
        renderApp()
    }
}

public func renderInteraction(@InteractionBuilder _ components: () -> [Renderable]) {
    print(components().render())
}
