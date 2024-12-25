//
//  Logger.swift
//  HealthChatExample
//
//  Created by Eric Hovhannisyan on 25.12.24.
//

import Foundation
import os

enum Logger {
    static let `default` = os.Logger(subsystem: Bundle.module.bundleIdentifier ?? "",
                                     category: "general")
    
    static func logDebug<T>(_ message: T) where T: CustomStringConvertible {
        `default`.debug("\(message)")
    }
}
