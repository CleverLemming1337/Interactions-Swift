//
//  File.swift
//  Interactions
//
//  Created by CleverLemming1337 on 11.11.24.
//

import Foundation
#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#else
#error("Unknown OS")
#endif

/// Clean up terminal and exit
func cleanUp() -> Never {
    AppRenderer.shared.showCursor()
    exit(SIGINT)
}

func interceptSignals() {
    signal(SIGINT) { _ in
        cleanUp()
    }
    signal(SIGWINCH) { _ in
        AppRenderer.shared.renderApp()
    }
}
