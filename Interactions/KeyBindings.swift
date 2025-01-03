//
//  KeyBindings.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation

public class KeyBinder: @unchecked Sendable {
    static let shared = KeyBinder()
    
    var bindings = [Key: () -> Void]()
    
    public func bind(with key: Key, to closure: @escaping () -> Void) {
        bindings[key] = closure
    }
    
    public func execute(with key: Key) {
        if let closure = bindings[key] {
            closure()
        }
    }
    
    public func unbind(key: Key) {
        bindings.removeValue(forKey: key)
    }
    
    func unbindAll() {
        bindings = [:]
    }
}
