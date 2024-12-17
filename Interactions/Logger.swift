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
    
    public func clearLogs() {
        logs = []
    }
    
    public func debug(_ message: String) {
        log(Log(level: .debug, message: message))
    }
    
    public func info(_ message: String) {
        log(Log(level: .info, message: message))
    }
    
    public func warn(_ message: String) {
        log(Log(level: .warning, message: message))
    }
    
    public func error(_ message: String) {
        log(Log(level: .error, message: message))
    }
}

struct RenderedLog: Interaction {
    let log: Log
    
    public var body: some Renderable {
        HStack {
            Text(log.date.description)
            Text("[\("\("\(log.level)", width: 7)".uppercased())]")
            Text(log.message)
        }
        .tint(log.level.color)
    }
}
struct LogList: Scene {
    @LegacyEnvironment(\.logger) var logger
    @LegacyEnvironment(\.rerender) var rerender
    
    let title = "Log"
    
    @State private var showDebug = false
    @State private var showInfo = true
    @State private var showWarning = true
    @State private var showError = true
    @State private var showFatal = true
    
    var filteredLogs: [Log] {
        get {
            logger.logs.filter({
                switch $0.level {
                case .debug: showDebug
                case .info: showInfo
                case .warning: showWarning
                case .error: showError
                case .fatal: showFatal
                }
            })
        }
    }
    
    var body: some Renderable {
        Button(.cA, "Clear logs") {
            logger.clearLogs()
            rerender()
        }
        Separator()
        VStack(spacing: 0) {
            Toggle(label: "Show debug info", key: .n0, isOn: $showDebug)
            Toggle(label: "Show info", key: .n1, isOn: $showInfo)
            Toggle(label: "Show warnings", key: .n2, isOn: $showWarning)
            Toggle(label: "Show errors", key: .n3, isOn: $showError)
            Toggle(label: "Show fatal errors", key: .n4, isOn: $showFatal)
        }
        Separator()
        if filteredLogs.count > 0 {
            for log in logger.logs.filter({
                switch $0.level {
                case .debug: showDebug
                case .info: showInfo
                case .warning: showWarning
                case .error: showError
                case .fatal: showFatal
                }
            }) {
                RenderedLog(log: log)
            }
        }
        else {
            Text("No logs available")
                .dark()
        }
    }
}
