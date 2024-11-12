//
//  Keyboard.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#else
#error("Unknown OS")
#endif

func enableRawMode() -> termios {
    var raw = termios()
    tcgetattr(STDIN_FILENO, &raw)
    let original = raw
    
    #if os(macOS)
    raw.c_lflag &= ~(UInt(ECHO | ICANON))
    #elseif os(Linux)
    raw.c_lflag &= ~(UInt32(ECHO | ICANON))
    #endif

    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw)
    return original
}

func disableRawMode(original: consuming termios) {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &original)
}

@discardableResult public func readKey() -> Key {
    var buf = [CChar](repeating: 0, count: 3)

    let readBytes = read(STDIN_FILENO, &buf, 1)
    guard readBytes > 0 else {
        return .null
    }
    
    print(buf)
    
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
    return Key(rawValue: Int16(buf[0])) ?? .null
}


func supportsAnsiCodes() -> Bool {
    guard let term = ProcessInfo.processInfo.environment["TERM"] else {
        return false
    }
    
    return term.lowercased() != "dumb"
}

public enum Key: Int16 {
    case null = 0
    case cA = 1
    case cB = 2
    case cD = 4
    case cE = 5
    case cF = 6
    case cG = 7
    case cH = 8
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
    
    // Symbols
    case exclamation = 33 // !
    case doubleQuote = 34 // "
    case hash = 35 // #
    case dollar = 36 // $
    case percent = 37 // %
    case ampersand = 38 // &
    case singleQuote = 39 // '
    case openParen = 40 // (
    case closeParen = 41 // )
    case asterisk = 42 // *
    case plus = 43 // +
    case comma = 44 // ,
    case minus = 45 // -
    case period = 46 // .
    case slash = 47 // /
    case colon = 58 // :
    case semicolon = 59 // ;
    case lessThan = 60 // <
    case equals = 61 // =
    case greaterThan = 62 // >
    case question = 63 // ?
    case at = 64 // @
    case openBracket = 91 // [
    case backslash = 92 // \
    case closeBracket = 93 // ]
    case caret = 94 // ^
    case underscore = 95 // _
    case backtick = 96 // `
    case openBrace = 123 // {
    case verticalBar = 124 // |
    case closeBrace = 125 // }
    case tilde = 126 // ~
    
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
    
    // Uppercase letters
    case A = 65
    case B = 66
    case C = 67
    case D = 68
    case E = 69
    case F = 70
    case G = 71
    case H = 72
    case I = 73
    case J = 74
    case K = 75
    case L = 76
    case M = 77
    case N = 78
    case O = 79
    case P = 80
    case Q = 81
    case R = 82
    case S = 83
    case T = 84
    case U = 85
    case V = 86
    case W = 87
    case X = 88
    case Y = 89
    case Z = 90

    // Lowercase letters
    case a = 97
    case b = 98
    case c = 99
    case d = 100
    case e = 101
    case f = 102
    case g = 103
    case h = 104
    case i = 105
    case j = 106
    case k = 107
    case l = 108
    case m = 109
    case n = 110
    case o = 111
    case p = 112
    case q = 113
    case r = 114
    case s = 115
    case t = 116
    case u = 117
    case v = 118
    case w = 119
    case x = 120
    case y = 121
    case z = 122
    
    // the following keys above 255 have self-defined values because they are normally represented by ANSI escape sequences (multiple bytes)
    
    // Arrows
    case arrowUp = 256
    case arrowDown = 257
    case arrowLeft = 258
    case arrowRight = 259
    
    // F1-F4
    case f1 = 260
    case f2 = 261
    case f3 = 262
    case f4 = 263
    
    // Whitespaces
    case space = 32
    case tab = 9
    case newLine = 10
    case carriageReturn = 13
    case backspace = 127
    case escape = 300
    
    public var name: String {
        get {
            keyNames[self.rawValue] ?? "�"
        }
    }
    
    public var string: String {
        get {
            keyStrings[self.rawValue] ?? ""
        }
    }
}

let keyNames: [Int16: String] = [
    1: "^A",
    2: "^B",
    3: "^C",
    4: "^D",
    5: "^E",
    6: "^F",
    7: "^G",
    8: "^H",
    9: "⇥",       // Tab
    10: "↵",      // Enter
    11: "^K",
    12: "^L",
    13: "↵",      // Carriage Return (CR)
    14: "^N",
    15: "^O",
    16: "^P",
    17: "^Q",
    18: "^R",
    19: "^S",
    20: "^T",
    21: "^U",
    22: "^V",
    23: "^W",
    24: "^X",
    25: "^Y",
    26: "^Z",
    27: "ESC",    // Escape

    32: "␣",      // Space
    33: "!",
    34: "\"",
    35: "#",
    36: "$",
    37: "%",
    38: "&",
    39: "'",
    40: "(",
    41: ")",
    42: "*",
    43: "+",
    44: ",",
    45: "-",
    46: ".",
    47: "/",
    
    48: "0",
    49: "1",
    50: "2",
    51: "3",
    52: "4",
    53: "5",
    54: "6",
    55: "7",
    56: "8",
    57: "9",
    
    58: ":",
    59: ";",
    60: "<",
    61: "=",
    62: ">",
    63: "?",
    64: "@",

    65: "A",
    66: "B",
    67: "C",
    68: "D",
    69: "E",
    70: "F",
    71: "G",
    72: "H",
    73: "I",
    74: "J",
    75: "K",
    76: "L",
    77: "M",
    78: "N",
    79: "O",
    80: "P",
    81: "Q",
    82: "R",
    83: "S",
    84: "T",
    85: "U",
    86: "V",
    87: "W",
    88: "X",
    89: "Y",
    90: "Z",

    91: "[",
    92: "\\",
    93: "]",
    94: "^",
    95: "_",
    96: "`",

    97: "a",
    98: "b",
    99: "c",
    100: "d",
    101: "e",
    102: "f",
    103: "g",
    104: "h",
    105: "i",
    106: "j",
    107: "k",
    108: "l",
    109: "m",
    110: "n",
    111: "o",
    112: "p",
    113: "q",
    114: "r",
    115: "s",
    116: "t",
    117: "u",
    118: "v",
    119: "w",
    120: "x",
    121: "y",
    122: "z",

    127: "backspace",
    
    256: "↑",
    257: "↓",
    258: "←",
    259: "→",
    260: "F1",
    261: "F2",
    262: "F3",
    263: "F4",
    
    300: "ESC",
]

let keyStrings: [Int16: String] = [
    9: "\t",       // Tab
    10: "\n",      // Enter
    13: "\r",      // Carriage Return (CR)
    32: " ",      // Space
    33: "!",
    34: "\"",
    35: "#",
    36: "$",
    37: "%",
    38: "&",
    39: "'",
    40: "(",
    41: ")",
    42: "*",
    43: "+",
    44: ",",
    45: "-",
    46: ".",
    47: "/",
    
    48: "0",
    49: "1",
    50: "2",
    51: "3",
    52: "4",
    53: "5",
    54: "6",
    55: "7",
    56: "8",
    57: "9",
    
    58: ":",
    59: ";",
    60: "<",
    61: "=",
    62: ">",
    63: "?",
    64: "@",

    65: "A",
    66: "B",
    67: "C",
    68: "D",
    69: "E",
    70: "F",
    71: "G",
    72: "H",
    73: "I",
    74: "J",
    75: "K",
    76: "L",
    77: "M",
    78: "N",
    79: "O",
    80: "P",
    81: "Q",
    82: "R",
    83: "S",
    84: "T",
    85: "U",
    86: "V",
    87: "W",
    88: "X",
    89: "Y",
    90: "Z",

    91: "[",
    92: "\\",
    93: "]",
    94: "^",
    95: "_",
    96: "`",

    97: "a",
    98: "b",
    99: "c",
    100: "d",
    101: "e",
    102: "f",
    103: "g",
    104: "h",
    105: "i",
    106: "j",
    107: "k",
    108: "l",
    109: "m",
    110: "n",
    111: "o",
    112: "p",
    113: "q",
    114: "r",
    115: "s",
    116: "t",
    117: "u",
    118: "v",
    119: "w",
    120: "x",
    121: "y",
    122: "z"
]
