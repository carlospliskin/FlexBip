//
//  Fleet.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 14/12/21.
//

import Foundation
import BSON

public class ConnectionData
{
    var serverAddress : String = "flexbip.com:85" //192.168.137.1
    var serverCommandPort : Int = 10000
    var serverVOIPPort : Int = 10000
    var localVOIPPort : Int = 10000
    var serverVideoPort : Int = 10001
    var localVideoPort : Int = 10001
    
}

public class FleetClientData {
    
    public var clientID : UUID!
    public var type : Int!
    public var userID : UUID!
    public var statusID : UUID!
    public var login : String!
    public var userName : String!
    public var deviceDescription : String!
    public var avatarHash : String = ""
    public var filtered : Bool = false;


    public init(deviceID : UUID, statusID : UUID, login : String, deviceDescription : String, avatarHash : String?)
    {
        self.clientID = deviceID
        self.statusID = statusID
        self.login = login
        self.deviceDescription = deviceDescription
        self.avatarHash = avatarHash ?? ""
    }
    public func ToJsonObjectNode(_ node : inout Document) -> Void
    {
        
        
    }

}

public enum LoginResponseCode : Int
{
    case OK = 0
    case Invalid_Version = 1
    case Invalid_Password = 2
    case Invalid_License_Expired = 3
    case Invalid_License_Exceeded_Clients = 4
    case Demo_Timeout = 5
    case Single_Login = 6
    case User_Locked = 7
}
public enum DataOps : Int
{
    case Initialize = 0
    case Add = 1
    case Remove = 2
    case Change = 3
    case UpdateGUI = 4
}
public class FleetUser
{
    public var userID : UUID!
    public var login : String!
    public var name : String!
    public var priority : Int!
    public var permissions : Int!
    public var filtered : Bool = false
}
public enum FleetDataType : Int
{
    case UNKNOWN = 0
    case CLIENTS = 10
    case USERS = 11
    case GROUPS = 12
    case STATUSES = 13
    case PASSWORD = 14
    case LOCATION_REQUESTS = 15
    case QUERYAVATAR = 20
    case AVATARRESPONSE = 21
    case QUERYLOGO = 22
    case LOGORESPONSE = 23
    case EMERGENCY_PROFILES = 30
    case COMPOUND = -1
}
public class FleetStatus
{
    public var statusID : UUID!
    public var type : Int!
    public var name : String!
    public var color : Int!
    

}
public enum LogLevel : Int
{
    case ERROR = 0
    case WARNING = 1
    case INFO = 2
    case DEBUG = 3
    case TRACE = 4
    case DIAGNOSTIC = 5
}

public enum ConfigResponseCode : Int
{
    case Sucsess = 0
    case Invalid_Version = 1
    case Invalid_Password = 2
    case User_Locked = 6
}

public enum ContentType : Int
{
    case PREVIEW = 0
    case DATA = 1
}

public enum ControlType : Int
{
    case CANCEL = 0
}

public enum FleetCommandType : Int16
{
    case UNKNOWN = 0
    case SERVER_CONFIG = 90
   // case UNKNOWN = 0
    case PING = 1
    case PONG = 2
    case WARMUP = 3
    case CONFIG_DEVICE_RESPONSE = 10
    case CONFIG_SERVER_RESPONSE_ACK = 11
    case CONFIG_SERVER_RESPONSE_NACK = 12
    case LOGIN_RESPONSE = 15
    case DEVICE_CONTEXT = 16
    case CONFIG_RESPONSE_PORTS = 18
    case SIMPLE_MESSAGE = 20


   // case SERVER_CONFIG = 90
    case DEVICE_CONFIG = 100
    case UPDATE = 103
    case UPDATE_INFO = 104
    case UPDATE_BLOCK = 105
    case LOGIN = 109
    case DEVICE_CONTROL = 120

    case TMS_DEVICE_REQUEST = 110
    case TMS_SERVER_REQUEST = 112
    case TMS_SERVER_RESPONSE = 122
    case TMS_COMPLETE = 130
    case TMS_CANCEL = 140

    case GPS_DEVICE_REQUEST = 150
    case GPS_SERVER_REQUEST = 152
    case GPS_RESPONSE = 160
    case GPS_RESULT_TO_SERVER = 170
    case GPS_RESULT_TO_CLIENT = 171
    case GPS_DEVICE_CANCEL = 180
    case GPS_SERVER_CANCEL = 182

    case CALL_INVITE = 190
    case CALL_RESPONSE = 200
    case CALL_CONTROL = 210

    case PTT_REQUEST = 220
    case PTT_RESPONSE = 230
    case PTT_CONTROL = 240
    case PTT_SELECT_GROUP = 241

    case DATAEX = 250
    case STATUS_CHANGE = 280
    case STATUS_CHANGE_REQUEST_FOR_DEVICE = 283
    case PASSWORD_CHANGE_REQUEST = 290
    case PASSWORD_CHANGE_RESPONSE = 300

    case STORAGE_STATUS_QUERY = 400
    case STORAGE_STATUS_RESPONSE = 410
    case STORAGE_JOB_REQUEST = 420
    case STORAGE_JOB_CONTENT = 430
    case STORAGE_JOB_CONTENT_REQUEST = 440
    case STORAGE_JOB_STATE = 450
    case STORAGE_JOB_CONTROL_REQUEST = 460
    case STORAGE_JOB_INFO = 470

    case OTAP_JOB_REQUEST = 500
    case OTAP_JOB_RESPONSE = 510
    case OTAP_JOB_STATE = 520
    case OTAP_JOB_CONTENT = 530
    case OTAP_JOB_CONTENT_REQUEST = 540
    case OTAP_SETTINGS_REQUEST = 550
    case OTAP_SETTINGS_RESPONSE = 560

    case RESOURCE_REQUEST = 700
    case RESOURCE_RESPONSE = 710
    case RESOURCE_READ = 720
    case RESOURCE_FETCH = 730
    case RESOURCE_CLOSE = 740

    case COMMAND_REQUEST = 800
    case COMMAND_RESPONSE = 810
    case COMMAND_CONFIRM = 820

    case DEVICE_STEALTH_CONTROL = 850

    case SYSTEM = 1000
}
public enum Reason : Int
{
    case NONE = 0
    case UNKNOWN = 1
    case FIRST_AVAILABLE = 2
    case LAST_AVAILABLE = 3
    case INVALID_DESTINATION = 4
}
public enum FleetProtocolType: Int16
{
    case BZON = 10000
    case OLD = 90
}
public enum FleetStream : Int
{
    case FLAG_NONE = 0
    case FLAG_COMPRESS = 1
}


