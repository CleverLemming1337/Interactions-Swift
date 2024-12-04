//
//  File.swift
//  Interactions
//
//  Created by Leonard Fekete on 02.12.24.
//

import Foundation

public protocol Activatable {
    func activate()
}

public extension Activatable {
    func bindActivation(with key: Key) {
        KeyBinder.shared.bind(with: key, to: activate)
    }
}
