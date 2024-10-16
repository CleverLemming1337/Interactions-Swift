//
//  Environment.swift
//  Interactions
//
//  Created by Leonard on 16.10.24.
//

import Foundation
<<<<<<< HEAD

public class EnvironmentProvider: @unchecked Sendable {
    public static let shared = EnvironmentProvider()
    
    public let renderer = AppRenderer.shared
    public let keyBinder = KeyBinder.shared
}

@propertyWrapper public struct Environment<T> {
    let path: KeyPath<EnvironmentProvider, T>
    
    public init(_ path: KeyPath<EnvironmentProvider, T>) {
        self.path = path
    }
    
    public var wrappedValue: T? {
        get {
            return EnvironmentProvider.shared[keyPath: path]
        }
    }
}
=======
>>>>>>> d9a840d326835afef9d18fa1213edace4e7aca2a
