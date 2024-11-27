//
//  State.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

public class Binding<T> {
    public var value: T {
        didSet {
            AppRenderer.shared.renderApp()
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
}

@propertyWrapper public struct State<T> {
    let binding: Binding<T>
    public init(wrappedValue: T) {
        self.stateitem = Binding<T>(wrappedValue)
    }
    public var wrappedValue: T {
        get {
            binding.value
        }
        nonmutating set {
            binding.value = newValue
        }
    }
    public var projectedValue {
        get {
            binding
        }
    }
}
