//
//  Keyboard.swift
//  Interactions
//
//  Created by Leonard on 15.10.24.
//

import Foundation
import Darwin

func enableRawMode() -> termios {
    var raw = termios()
    tcgetattr(STDIN_FILENO, &raw)
    let original = raw
    
    raw.c_lflag &= ~(UInt(ECHO | ICANON))
    
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw)
    return original
}

func disableRawMode(original: consuming termios) {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &original)
}

public /* TODO: remove `public` */ func readKey() -> Key {
    var buf = [CChar](repeating: 0, count: 2)
    read(STDIN_FILENO, &buf, 1)
    return Key(rawValue: UInt8(buf[0])) ?? Key.null
}

func supportsAnsiCodes() -> Bool {
    guard let term = ProcessInfo.processInfo.environment["TERM"] else {
        return false
    }
    
    return term.lowercased() != "dumb"
}
