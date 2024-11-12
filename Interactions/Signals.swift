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

func interceptSignals() {
    signal(SIGINT) { _ in
        AppRenderer.shared.showCursor()
        exit(SIGINT)
    }
    signal(SIGWINCH) { _ in
        AppRenderer.shared.renderApp()
    }
}
