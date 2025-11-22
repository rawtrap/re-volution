//
//  Logger.swift
//  KardashevGame
//
//  Sistema di logging centralizzato per debugging e error handling
//

import Foundation

/// Sistema di logging per debug e monitoring
enum Logger {
    enum Level: String {
        case debug = "🔍 DEBUG"
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "❌ ERROR"
        case success = "✅ SUCCESS"
    }
    
    /// Log a debug message
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message: message, file: file, function: function, line: line)
    }
    
    /// Log an info message
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message: message, file: file, function: function, line: line)
    }
    
    /// Log a warning
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .warning, message: message, file: file, function: function, line: line)
    }
    
    /// Log an error
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message: message, file: file, function: function, line: line)
    }
    
    /// Log a success message
    static func success(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .success, message: message, file: file, function: function, line: line)
    }
    
    /// Core logging function
    private static func log(
        level: Level,
        message: String,
        file: String,
        function: String,
        line: Int
    ) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        print("\(timestamp) [\(level.rawValue)] [\(fileName):\(line)] \(function) - \(message)")
        #endif
    }
}

// MARK: - Transaction Logging

extension Logger {
    /// Log resource transaction
    static func transaction(
        resource: String,
        amount: String,
        type: TransactionType,
        success: Bool
    ) {
        let emoji = type == .add ? "➕" : "➖"
        let status = success ? "✅" : "❌"
        info("\(status) \(emoji) \(resource): \(amount)")
    }
    
    enum TransactionType {
        case add, subtract
    }
}

// MARK: - Performance Logging

extension Logger {
    /// Measure and log execution time
    static func measure<T>(
        _ label: String,
        operation: () -> T
    ) -> T {
        let start = Date()
        let result = operation()
        let duration = Date().timeIntervalSince(start)
        debug("\(label) completed in \(String(format: "%.3f", duration))s")
        return result
    }
}

// MARK: - Date Formatter Extension

private extension DateFormatter {
    static let logTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
