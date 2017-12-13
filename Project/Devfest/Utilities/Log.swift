//
//  Created by Pavel Dolezal on 26/06/15.
//  Copyright (c) 2013 eMan s.r.o. All rights reserved.
//

import Foundation

/**
Simple logging tool for Swift projects.

Use global logger whenever possible:

    #if DEBUG
    Log.enabled = true
    #endif
    Log.level = .Info
    Log.info("Hello \(name)")

Alternatively you can use custom logger which is useful mostly during
develompment time if you are debugging certain parts of the app:

   let privateLogger = Log(level: .Debug)
   privateLogger.debug("User tapped button")
*/
open class Log {
    
    /// Log level indicates how serious the log entry is.
    /// Lower number means higher priority.
    public enum Level: Int {
        case none, error, warn, info, debug
        
        /// String representation for printing.
        fileprivate var str: String {
            switch(self) {
            case .none: return  ""
            case .error: return "ERROR"
            case .warn: return  "WARN "
            case .info: return  "INFO "
            case .debug: return "DEBUG"
            }
        }
    }
    
    /// Sets wether logging is enabled. Useful for keeping all logging off
    /// for production deployment.
    open static var enabled = false
    
    /// Minimum log level for output. Levels with lower priority are ignored.
    open var level: Level
    
    public init(level: Level) {
        self.level = level
    }
    
    fileprivate let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return fmt
    }()

    // MARK: - Instance methods

    fileprivate func log(_ level: Level, str: String, file: String = #file, line: Int = #line) {
        if Log.enabled && level.rawValue <= self.level.rawValue {
            let dateString = dateFormatter.string(from: Date())
            let url = URL(string: file)
            let file: String = url?.lastPathComponent ?? "unknown"
            print("\(dateString) \(level.str) [\(file):\(line)]: \(str)")
        }
    }
    
    /// Logs error if level is at least .Error.
    open func error(_ str: String, file: String = #file, line: Int = #line) {
        log(.error, str: str, file: file, line: line)
    }
    
    /// Logs warning if level is at least .Warn.
    open func warn(_ str: String, file: String = #file, line: Int = #line) {
        log(.warn, str: str, file: file, line: line)
    }
    
    /// Logs info if level is at least .Info.
    open func info(_ str: String, file: String = #file, line: Int = #line) {
        log(.info, str: str, file: file, line: line)
    }
    
    /// Logs error if level is at least .Debug.
    open func debug(_ str: String, file: String = #file, line: Int = #line) {
        log(.debug, str: str, file: file, line: line)
    }
    
    // MARK: - Shared logger
    
    static var sharedLogger: Log = Log(level: .info)
    
    open static var level: Level {
    get {
        return sharedLogger.level
    }
    set {
        sharedLogger.level = newValue
    }
    }
    
    open static func error(_ str: String, file: String = #file, line: Int = #line) {
        self.sharedLogger.error(str, file: file, line: line)
    }
    
    open static func warn(_ str: String, file: String = #file, line: Int = #line) {
        self.sharedLogger.warn(str, file: file, line: line)
    }
    
    open static func info(_ str: String, file: String = #file, line: Int = #line) {
        self.sharedLogger.info(str, file: file, line: line)
    }
    
    open static func debug(_ str: String, file: String = #file, line: Int = #line) {
        self.sharedLogger.debug(str, file: file, line: line)
    }
   
}
