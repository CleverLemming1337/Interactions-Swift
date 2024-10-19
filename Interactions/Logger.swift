//
//  Logger.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation

public enum LogLevel {
    case debug
    case info
    case warning
    case error
    case fatal
    
    var color: Color {
        get {
            switch self {
            case .debug: return .white
            case .info: return .cyan
            case .warning: return .yellow
            case .error: return .red
            case .fatal: return .red
            }
        }
    }
}

public struct Log: CustomStringConvertible {
    public let level: LogLevel
    public let message: String
    public let date = Date()
    
    public var description: String {
        get {
            "\(date) [\(level)] \(message)"
        }
    }
    
    public init(level: LogLevel, message: String) {
        self.level = level
        self.message = message
    }
    
    
}

public class Logger: @unchecked Sendable {
    static let shared = Logger()
    
    public var logs = [Log]()
    
    public func log(_ log: Log) {
        logs.append(log)
    }
}

struct RenderedLog: Interaction {
    let log: Log
    
    public var body: some Renderable {
        HStack {
            Text(log.date.description)
            Text("[\("\(centered: "\(log.level)", width: 7)".uppercased())]")
            Text(log.message)
        }
        .tint(log.level.color)
    }
}
struct LogList: Scene {
    @Environment(\.logger) var logger
    let title = "Log"
    
    var body: some Renderable {
        for log in logger.logs {
            RenderedLog(log: log)
        }
    }
}
