//
//  Log.swift
//  WolfLog
//
//  Created by Wolf McNally on 12/10/15.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import ExtensibleEnumeratedName
import WolfStrings

public enum LogLevel: Int, Comparable {
    case trace
    case info
    case warning
    case error

    private static let symbols = ["🔷", "✅", "⚠️", "🛑"]

    public var symbol: String {
        return type(of: self).symbols[rawValue]
    }

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func == (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public var logger: Log? = Log()

public struct LogGroup: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

public class Log {
    public var level = LogLevel.trace
    public var locationLevel = LogLevel.error
    public private(set) var groupLevels = [LogGroup: LogLevel]()

    public func print<T>(_ message: @autoclosure () -> T, level: LogLevel, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {

        // Don't print if the global level is below the level of this message.
        guard level >= self.level else { return }

        // Do print if there's no group associated with the message.
        if let group = group {
            // Don't print unless there's a level defined for the group.
            guard let groupLevel = groupLevels[group] else { return }
            // Don't print unless the level of the associated group is at or above the global level.
            guard groupLevel >= self.level else { return }
            // Don't print unless the level of the message is at or above the level of the associated group.
            guard level >= groupLevel else { return }
        }

        let a = Joiner()
        a.append(level.symbol)

        if let group = group {
            let b = Joiner(left: "[", separator: ", ", right: "]")
            b.append(group.rawValue)
            a.append(b)
        }

        if let obj = obj {
            a.append(obj)
        }

        a.append(message())

        Swift.print(a)

        if level >= self.locationLevel {
            let d = Joiner(separator: ", ")
            d.append(shortenFile(file), "line: \(line)", function)
            Swift.print(String.tab, d)
        }
    }

    public func isGroupActive(_ group: LogGroup) -> Bool {
        return groupLevels[group] != nil
    }

    public func setGroup(_ group: LogGroup, active: Bool = true, level: LogLevel = .trace) {
        if active {
            groupLevels[group] = level
        } else {
            groupLevels[group] = nil
        }
    }

    private func shortenFile(_ file: StaticString) -> String {
        let components = file.description.components(separatedBy: "/")
        let originalCount = components.count
        let newCount = min(3, components.count)
        let end = originalCount
        let begin = end - newCount
        let lastComponents = components[begin..<end]
        let result = lastComponents.joined(separator: "/")
        return result
    }

    public func trace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
        self.print(message(), level: .trace, obj: obj, group: group, file, line, function)
    }

    public func info<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
        self.print(message(), level: .info, obj: obj, group: group, file, line, function)
    }

    public func warning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
        self.print(message(), level: .warning, obj: obj, group: group, file, line, function)
    }

    public func error<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
        self.print(message(), level: .error, obj: obj, group: group, file, line, function)
    }
}

public func logTrace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.trace(message(), obj: obj, group: group, file, line, function)
    #endif
}

public func logInfo<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.info(message(), obj: obj, group: group, file, line, function)
    #endif
}

public func logWarning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.warning(message(), obj: obj, group: group, file, line, function)
    #endif
}

public func logError<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.error(message(), obj: obj, group: group, file, line, function)
    #endif
}

public func logFatalError<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: StaticString = #file, _ line: UInt = #line, _ function: String = #function) -> Never {
    #if !NO_LOG
        logger?.error(message(), obj: obj, group: group, file, line, function)
    #endif
    fatalError(String(describing: message()), file: file, line: line)
}
