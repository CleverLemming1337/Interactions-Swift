//
//  Environment.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation

public class EnvironmentProvider: @unchecked Sendable {
    public static let shared = EnvironmentProvider()
    
    public let renderer = AppRenderer.shared
    public let keyBinder = KeyBinder.shared
    public let logger = Logger.shared
    public private(set) var settings: AppSettings = AppSettings(set: false)
    public let rerender = AppRenderer.shared.renderApp
    
    public var terminalSize: (UInt16, UInt16) {
        get {
            AppRenderer.shared.terminalSize
        }
    }
    public var tabIndex: Int {
        get {
            TabManager.shared.tabIndex
        }
        set {
            TabManager.shared.tabIndex = newValue
        }
    }
    
    func setSettings(_ settings: AppSettings) {
        self.settings = settings
    }
    
    public var dismiss = {
        AppRenderer.shared.back()
    }
}

@propertyWrapper public struct Environment<T> {
    let path: KeyPath<EnvironmentProvider, T>
    
    public init(_ path: KeyPath<EnvironmentProvider, T>) {
        self.path = path
    }
    
    public var wrappedValue: T {
        get {
            return EnvironmentProvider.shared[keyPath: path]
        }
    }
}
