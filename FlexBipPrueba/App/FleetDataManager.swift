//
//  FleetDataManager.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 14/12/21.
//

import Foundation
import SQLite3

public enum EventTypes: Int16
{
    case NONE = 0
    case REGISTRATION = 1
    case VOICE_CALL = 2
    case VIDEO_CALL = 3
    case TEXT = 4
    case VOICE_REMOTE_MONITORING = 5
    case VIDEO_REMOTE_MONITORING = 6
    case STATUS = 7
    case TELEMETRY = 8
    case JOB = 9
    case VOICE_PTT_CALL = 10
    case VIDEO_PTT_CALL = 11
    case IMAGE = 12
    case FILE = 13
    case VIDEO = 14
    case VOICEREC = 15
    case CALL_ALERT = 16
}
public enum EventState: Int16
{
    case NONE = 0
    case CALL_INITIATED = 1
    case CALL_ACCEPTED = 2
    case CALL_DECLINED = 3
    case CALL_MISSED = 4
    case CALL_MISSED_ACK = 14
    case CALL_NOTANSWERED = 5
    case CALL_FINISHED = 12
    case MESSAGE_INITIATED = 6 //message sent to server
    case MESSAGE_UNREAD = 7 //message received but not read
    case MESSAGE_READ = 8 //message read by user
    case MESSAGE_DELIVERED = 9 //message delivered to destination device
    case MESSAGE_CANCELED = 10 //message delivery canceled
    case MESSAGE_ACCEPTED = 11 //message accepted by server
    case MESSAGE_FAILED = 13 //failed to send the message
}
public enum EventDirection: Int16
{
    case INCOMING = 1
    case OUTGOING = 2
}
public enum ObjectType: Int16
{
    case DEVICE = 1
    case USER = 2
    case GROUP = 3
}

public class UnreadItem
{
    var texts: Int = 0
    var calls: Int = 0
}
public class FleetEvent
{
    var eventID: Int = 0
    var eventUUID: UUID = .Empty
    var direction: Int = 0
    var type: Int = 0
    var state: Int = 0
    var date: Int64 = 0
    var deviceID: UUID = .Empty
    var deviceDesc: String = ""
    var userID: UUID = .Empty
    var userName: String = ""
    var groupID: UUID = .Empty
    var groupName: String = ""
    var thisUserID: UUID = .Empty
    var platform: Int = 0
    var platform_descr: String = ""
    var content: String = ""
    var previewPath: String = ""
    var dataPath: String = ""
    var duration: Int = 0
    var sequence: Int = 0
}



public class FleetDataManager {
    private static var m : FleetDataManager!
    public static var unreadItemsU: [UUID: UnreadItem] = [:]
    public static var unreadItemsG: [UUID: UnreadItem] = [:]

    public static var manager: FleetDataManager
    {
        if (FleetDataManager.m  == nil)
        { FleetDataManager.m = FleetDataManager() }
        
        return FleetDataManager.m
    }
    
    public static func Initialize ()
    {
        let dbFile = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("fleet.sqlite")
        
        
    }
    
    
    
    
}
