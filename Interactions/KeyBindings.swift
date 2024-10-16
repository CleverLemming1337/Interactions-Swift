//
//  KeyBindings.swift
//  Interactions
//
//  Created by Leonard on 16.10.24.
//

import Foundation
<<<<<<< HEAD

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
}
=======
>>>>>>> d9a840d326835afef9d18fa1213edace4e7aca2a
