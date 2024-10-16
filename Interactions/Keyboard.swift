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

public func readKey() -> Key {
    var buf = [CChar](repeating: 0, count: 3)

    let readBytes = read(STDIN_FILENO, &buf, 1)
    guard readBytes > 0 else {
        return .null
    }
    
    if buf[0] == 27 {
        
        let readMore = read(STDIN_FILENO, &buf[1], 2)
        
        guard readMore >= 1 else {
            return .null
        }
        
        if buf[1] == 91 {
            
            guard readMore == 2 else {
                return .null
            }
            
            switch buf[2] {
            case 65: return .arrowUp
            case 66: return .arrowDown
            case 67: return .arrowRight
            case 68: return .arrowLeft
            default: return .null
            }
        }
        if buf[1] == 79 { // F1 - F4
            
            guard readMore == 2 else {
                return .null
            }
            
            switch buf[2] {
            case 80: return .f1
            case 81: return .f2
            case 82: return .f3
            case 83: return .f4
            default: return .null
            }
        }
        if buf[1] == 27 { // ESC
            switch buf[2] {
            case 0: return .escape
            default: return .null
            }
        }
        
    }
    
    // Falls es keine Escape-Sequenz war, gib das einfache Zeichen zurück
    return Key(rawValue: UInt16(buf[0])) ?? .null
}


func supportsAnsiCodes() -> Bool {
    guard let term = ProcessInfo.processInfo.environment["TERM"] else {
        return false
    }
    
    return term.lowercased() != "dumb"
}

public enum Key: UInt16 {
    case null = 0
    case cA = 1
    case cB = 2
    case cD = 4
    case cE = 5
    case cF = 6
    case cG = 7
    case cH = 8
    case tab = 9
    case enter = 10
    case cK = 11
    case cL = 12
    case cN = 14
    case cP = 16
    case cQ = 17
    case cR = 18
    case cS = 19
    case cT = 20
    case cU = 21
    case cV = 22
    case cW = 23
    case cX = 24
    case cY = 25
    case cZ = 26
    
    case n0 = 48
    case n1 = 49
    case n2 = 50
    case n3 = 51
    case n4 = 52
    case n5 = 53
    case n6 = 54
    case n7 = 55
    case n8 = 56
    case n9 = 57
    
    case arrowUp = 256
    case arrowDown = 257
    case arrowLeft = 258
    case arrowRight = 259
    case f1 = 260
    case f2 = 261
    case f3 = 262
    case f4 = 263
    case escape = 300
    
    public func toString() -> String {
        return keyNames[self.rawValue] ?? "�"
    }
}

public let keyNames: [UInt16: String] = [
    1: "^A",
    2: "^B",
    3: "^C",
    4: "^D",
    5: "^E",
    6: "^F",
    7: "^G",
    8: "^H",
    9: "⇥",
    10: "↵",
    11: "^K",
    12: "^L",
    14: "^N",
    16: "^P",
    17: "^Q",
    18: "^R",
    19: "^S", //
    20: "^T", //
    21: "^U", //
    22: "^V",
    23: "^W",
    24: "^X",
    25: "^Y", // command suspension
    26: "^Z",  // "
    
    48: "0",
    49: "1",
    50: "2",
    51: "3",
    52: "4",
    53: "5",
    54: "6",
    58: "7",
    59: "8",
    60: "9",
    
    256: "↑",
    257: "↓",
    258: "←",
    259: "→",
    260: "F1",
    261: "F2",
    262: "F3",
    263: "F4",
    
    300: "ESC"
]
