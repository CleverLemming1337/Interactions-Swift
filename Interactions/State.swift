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
            print("Re-render")
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
    let binding: Binding<T>
    public init(wrappedValue: T) {
        self.binding = Binding<T>(wrappedValue)
    }
    public var wrappedValue: T {
        get {
            binding.value
        }
        nonmutating set {
            binding.value = newValue
        }
    }
    public var projectedValue: Binding<T> {
        binding
    }
}
