//
//  State.swift
//  Interactions
//
//  Created by Leonard on 15.10.24.
//

import Foundation

public class StateItem<T> {
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
    let stateitem: StateItem<T>
    public init(wrappedValue: T) {
        self.stateitem = StateItem<T>(wrappedValue)
    }
    public var wrappedValue: T {
        get {
            stateitem.value
        }
        set {
            stateitem.value = newValue
        }
    }
}
