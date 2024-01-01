//
//  FleetMessage.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 13/12/21.
//

import Foundation
import BSON


public class FleetMessage : NSObject
{
    var _bytes : [UInt8]?

    public var CommandType : FleetCommandType = .UNKNOWN
    public var ProtocolType: FleetProtocolType = .BZON
    public var Compressed : Bool = false
    public var ForLog : Bool = false
    
    public init(commandType : FleetCommandType, _ flags : FleetStream = .FLAG_NONE)
    {
        CommandType = commandType
        Compressed = flags == .FLAG_COMPRESS
    }

    public init(bytes: [UInt8])
    {
        _bytes = bytes
    }

    public static func Parse(data: Data) -> FleetMessage?
    {
        let bytes = [UInt8](data)
        let protocolType = FleetProtocolType(rawValue: parseInt16(bytes: bytes, offset: 0))!
        let commandType : FleetCommandType
        var bodyOffset : Int
        var compressed : Bool = false
        var bodyBytes : [UInt8]?
        if (protocolType == .BZON)
        {
            //protocol type (19 36)
            // command type (90 0)
            // flags byte (0)
            // data lenth (x x x x)
            commandType = FleetCommandType(rawValue: parseInt16(bytes: bytes, offset: 2))!
            if (bytes.count > 4)
            {
                compressed = bytes[4] != 0
                bodyOffset = 9
                
                if (compressed)
                {
                    var sizeArray = [UInt8]([ 0, 0, 0, 0])
                    Utils.ArrayCopy(bytes, 5, &sizeArray, 0, 4)
                    let dataSize = Int(exactly: parseInt32(bytes: sizeArray, offset: 0))!
                    let compressedBytes = Array(bytes[bodyOffset..<bytes.count])
                   let decompressedBytes = Utils.DecompressData(compressedBytes, dataSize)
                    
                    
                   // if (decompressedBytes == nil)
                    //{
                      //  return nil
                    //}
                                    }
                else
                {
                    bodyBytes = Array(bytes[bodyOffset..<bytes.count])
                }
            }
        }
        else
        {
            // command type (90 0)
            // flags byte (0)
            // data lenth (32 0 0 0)
            commandType = FleetCommandType(rawValue: parseInt16(bytes: bytes, offset: 0))!
            bodyOffset = 7
            bodyBytes = Array(bytes[bodyOffset..<bytes.count])
        }
        
        var message : FleetMessage?
        //MARK: SERVER CONFIG
        
        switch (protocolType)
        {
            case .OLD: // SERVER_CONFIG
                message = ConfigMessage(bytes: bodyBytes!)
            case .BZON:
                var bsonDocument : Document! = nil
                if (bodyBytes != nil)
                    { /*bsonDocument = Document.init(data: bodyBytes!)*/ }
                print ("-------")
                print (bsonDocument)
                
                switch(commandType)
                {
                   case .CONFIG_SERVER_RESPONSE_ACK:
                        message = SessionConfigResponseACK(bsonDocument)
                        break
                /*
                    case .CONFIG_SERVER_RESPONSE_NACK:
                        message = SessionConfigResponseNACK(bsonDocument)
                        break
                    case .LOGIN_RESPONSE:
                        message = LoginResponse(bsonDocument)
                        break
                    case .DEVICE_CONTEXT:
                        message = DeviceContext(bsonDocument)
                        break
                    case .DATAEX:
                        message = DataExchange(bsonDocument)
                        break

                    case .STATUS_CHANGE_REQUEST_FOR_DEVICE:
                        message = StatusChange(bsonDocument)
                        break
                    */
                    
                  /*  case .STORAGE_STATUS_QUERY:
                        message = ConversationStateQuery(bsonDocument)
                        break
                    case .STORAGE_JOB_REQUEST:
                        message = StorageJobRequest(bsonDocument)
                        break
                    case .STORAGE_JOB_STATE:
                        message = StorageJobUpdate(bsonDocument)
                        break
                    case .STORAGE_JOB_INFO:
                        message = StorageJobInfo(bsonDocument)
                        break
                    case .STORAGE_JOB_CONTENT_REQUEST:
                        message = StorageJobDataRequest(bsonDocument)
                        break
                    case .STORAGE_JOB_CONTENT:
                        message = StorageJobData(bsonDocument)
                        break

                    */
                    
                 /*   case .GPS_SERVER_REQUEST:
                        message = LocationRequest(bsonDocument)
                        break
                    case .GPS_RESULT_TO_CLIENT:
                        message = DeviceLocation(bsonDocument)
                        break
                    case .GPS_SERVER_CANCEL:
                        message = LocationCancel(bsonDocument)
                        break
                    
//                    case .CALL_INVITE:
//                        break
//                    case .CALL_RESPONSE:
//                        break
//                    case .CALL_CONTROL:
//                        break

                    case .COMMAND_REQUEST:
                        message = ControlCommand(bsonDocument)
                        break
                    case .COMMAND_RESPONSE:
                        message = ControlCommandResponse(bsonDocument)
                        break
                    case .COMMAND_CONFIRM:
                        message = ControlCommandConfirmation(bsonDocument)
                        break

                    
                    
                    case .PTT_RESPONSE:
                        message = DevicePttResponse(bsonDocument)
                        break
                    case .PTT_CONTROL:
                        message = DevicePttControl(bsonDocument)
                        break
                    
                    
                    
                    case .PASSWORD_CHANGE_RESPONSE:
                        message = PasswordChangeResponse(bsonDocument)
                        break

                    */
                    
                    default:
                       // message = UnknownMessage(bsonDocument)
                        break
                }
                break
        }

        if (message != nil)
        {
            message!.CommandType = commandType
            message!.ProtocolType = protocolType
        }

        return message
    }
    
    public func ToObjectNode() -> Document?
    {
        return nil;
    }

    public func CreateObjectNode() -> Document
    {
        return Document()
    }
    
    public func CreateArrayNode() -> Document
    {
        let doc = Document(array: [Primitive?]())
        return doc
    }

    public func parseInt32(bytes:[UInt8], offset:Int)->Int32
    {

        var pointer: UnsafePointer<UInt8> = UnsafePointer<UInt8>(bytes)
        pointer = pointer.advanced(by: offset)

        let rawPointer = UnsafeRawPointer(pointer)
        return rawPointer.load(as: Int32.self)
    }

    public func parseInt16(bytes:[UInt8], offset:Int)->Int16
    {

        var pointer: UnsafePointer<UInt8> = UnsafePointer<UInt8>(bytes)
        pointer = pointer.advanced(by: offset)

        let rawPointer = UnsafeRawPointer(pointer)
        return rawPointer.load(as: Int16.self)
    }

    public static func parseInt32(bytes:[UInt8], offset:Int)->Int32
    {

        var pointer: UnsafePointer<UInt8> = UnsafePointer<UInt8>(bytes)
        pointer = pointer.advanced(by: offset)

        let rawPointer = UnsafeRawPointer(pointer)
        return rawPointer.load(as: Int32.self)
    }

    public static func parseInt16(bytes:[UInt8], offset:Int)->Int16
    {

        var pointer: UnsafePointer<UInt8> = UnsafePointer<UInt8>(bytes)
        pointer = pointer.advanced(by: offset)

        let rawPointer = UnsafeRawPointer(pointer)
        return rawPointer.load(as: Int16.self)
    }
    
    public override var description : String
    {
        return "\(type(of: self)).\(CommandType)"
    }
        

}
