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
