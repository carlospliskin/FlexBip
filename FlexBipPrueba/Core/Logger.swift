//
//  Logger.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 10/12/21.
//

import Foundation
import os


public class Logger {
    
    //private static var queue = Queue<FleetSimpleMessage>()
    public static var VerboseForServer : Bool = false
    public static var activeClient : FleetClient!
    public static var _lockObject : NSLock = NSLock()

    private static func FormatMessage(_ tag : String, _ msg : String) -> String
    {
        return "\(tag) \(msg)"
    }
    
    private static func SendToServer(_ level : LogLevel, _ tag : String, _ msg : String) -> Void
    {
        
    }
    
    public static func e(_ tag : String, _ msg : String) -> Void
    {
        print("\(GetFormattedNow()) \(tag) \(msg)")
        if (VerboseForServer)
            { SendToServer(LogLevel.ERROR, tag, msg) }
    }
    public static func e(_ tag : String, _ msg : String, er : Error) -> Void
    {
       let newMsg = msg + ": " + er.localizedDescription
        e(tag, newMsg)
    }

    public static func v(_ tag : String, _ msg : String) -> Void
    {
       print("\(GetFormattedNow()) \(tag) \(msg)")
        if (VerboseForServer)
            { SendToServer(LogLevel.TRACE, tag, msg) }
    }
    public static func GetFormattedNow() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        return timestamp
    }
    
}
extension OSLog
{
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let general = OSLog(subsystem: subsystem, category: "general")
}
