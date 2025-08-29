import os

enum Log {
    private static let logger = Logger(subsystem: "com.yourcompany.rakhiconnect", category: "app")
    static func info(_ msg: String) { logger.info("\(msg)") }
    static func error(_ msg: String) { logger.error("\(msg)") }
}
