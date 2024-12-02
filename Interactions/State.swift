//
//  State.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation


@propertyWrapper public class Binding<T> {
    var value: T {
        didSet {
            AppRenderer.shared.renderApp()
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
    
    public var wrappedValue: T {
        get {
            value
        }
        set {
            value = newValue
        }
    }
    
    public var projectedValue: Binding<T> {
        self
    }
}

// Add a state storage class
private class StateStorage: @unchecked Sendable {
    static let shared = StateStorage()
    var storage: [String: Any] = [:]
}

@propertyWrapper public struct State<T> {
    let id: String
    let defaultValue: T
    
    public init(wrappedValue: T) {
        self.defaultValue = wrappedValue
        // Create unique ID based on file and line where @State is used
        self.id = "\(#file):\(#line)"
    }
    
    public var wrappedValue: T {
        get {
            if let value = StateStorage.shared.storage[id] as? T {
                return value
            }
            StateStorage.shared.storage[id] = defaultValue
            return defaultValue
        }
        nonmutating set {
            StateStorage.shared.storage[id] = newValue
            AppRenderer.shared.renderApp()
        }
    }
    
    public var projectedValue: Binding<T> {
        Binding(wrappedValue)
    }
}
