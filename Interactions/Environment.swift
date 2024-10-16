//
//  Environment.swift
//  Interactions
//
//  Created by Leonard on 16.10.24.
//

import Foundation

public class EnvironmentProvider: @unchecked Sendable {
    public static let shared = EnvironmentProvider()
    
    public let renderer = AppRenderer.shared
    public let keyBinder = KeyBinder.shared
    public let logger = Logger.shared
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
