//
//  Logger.swift
//  Interactions
//
//  Created by Leonard on 16.10.24.
//

import Foundation

public enum LogLevel {
    case debug
    case info
    case warning
    case error
    case fatal
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
    
    public func printLogs() {
        for log in logs {
            print(log)
        }
    }
    
    public func log(_ log: Log) {
        logs.append(log)
    }
}
