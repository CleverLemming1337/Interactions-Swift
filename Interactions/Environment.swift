//
//  Environment.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation
import Dependencies

public typealias Environment = Dependency

public extension DependencyValues {
    var accentColor: Color {
        get { self[AccentColorKey.self] }
        set { self[AccentColorKey.self] = newValue }
    }
}

private enum AccentColorKey: DependencyKey {
    static let liveValue: Color = .cyan
    static let testValue: Color = .red
}

public extension Renderable {
    func environment<T>(_ path: WritableKeyPath<DependencyValues, T>, _ value: T) -> some Renderable {
        DependencyWrapper(content: self) {
            $0[keyPath: path] = value
        }
    }
}

private struct DependencyWrapper<Content: Renderable>: Renderable {
    let content: Content
    let modify: (inout DependencyValues) -> Void
    
    func render() -> String {
        withDependencies {
            modify(&$0)
        } operation: {
            content.render()
        }
    }
}

public typealias Hook = @Sendable () -> Void
