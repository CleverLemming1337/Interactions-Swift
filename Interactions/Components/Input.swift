//
//  Input.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation


//struct RawInput: Renderable {
//    let terminator: UInt8
//    let pressedKey = StateItem<UInt8?>(nil)
//    let input = StateItem<[UInt8]>([])
//    
//    init(terminator: UInt8 = 10) {
//        self.terminator = terminator
//    }
//    
//    func render() -> String {
//        while pressedKey.value != terminator {
//            pressedKey.value = readKey()
//            if pressedKey.value != terminator {
//                input.value.append(pressedKey.value ?? 0)
//            }
//        }
//        return input.value.map { "[\($0)]" }.joined()
//    }
//    
//    
//}
//
//public struct TextInput: Interaction {
//    let prompt: String
//    
//    public init(prompt: String) {
//        self.prompt = prompt
//    }
//    
//    public var body: some Renderable {
//        Text(prompt)
//        RawInput()
//    }
//}

public struct Button: Interaction {
    let key: Key
    let label: String
    let action: () -> Void
    
    public init(_ key: Key, _ label: String, _ action: @escaping () -> Void) {
        self.key = key
        self.label = label
        self.action = action
        
        @Environment(\.keyBinder) var keyBinder
        
        keyBinder?.bind(with: key, to: action)
    }
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            Text(key.toString())
                .padding()
                .other("[100m", end: "[49m")
                
            Text("\(label)")
                .padding()
                .reversed()
        }
    }
    
}
