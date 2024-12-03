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

@propertyWrapper public struct State<T> {
    let id: String
    let defaultValue: T
    
    public init(wrappedValue: T, file: StaticString = #file, line: UInt = #line) {
        self.defaultValue = wrappedValue
        // Create unique but persistent (=not random) ID based on file and line where @State is used
        self.id = "\(file):\(line)"

        // Store the binding in the storage if it doesn't exist yet
        if StateStorage.shared.storage[id] == nil {
            StateStorage.shared.storage[id] = Binding(defaultValue)
        }
    }
    
    public var wrappedValue: T {
        get {
            if let binding = StateStorage.shared.storage[id] as? Binding<T> {
                if let value = binding.value as? T {
                    return value
                }
            }
            StateStorage.shared.storage[id] = Binding(defaultValue)
            return defaultValue
        }
        nonmutating set {
            (StateStorage.shared.storage[id] as? Binding)?.value = newValue
        }
    }
    
    public var projectedValue: Binding<T> {
        if let binding = StateStorage.shared.storage[id] as? Binding<T> {
            return binding
        }
        return Binding<T>(defaultValue)
    }

}


public class StateStorage: @unchecked Sendable {
    public static let shared = StateStorage()
    public var storage: [String: Any /* Baically Binding<Any>. Binding<Any> can't
     be converted to Binding<T>, but Any can be converted to both Binding<Any> and Binding<T> */
     ] = [:]
}
