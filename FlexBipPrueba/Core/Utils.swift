//
//  Utils.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 07/12/21.
//

import Foundation
import UIKit
import Compression
import CommonCrypto
import BSON

public class Utils {
    
    public typealias Bytes = [UInt8]
    
    public static func DecompressData(_ data: [UInt8], _ size : Int) -> Bytes?
    {
        let compressedData = Data(data)
        let decompressedData = compressedData.gunzip()
        if (decompressedData == nil)
        {
            return nil
        }
        
        return [UInt8](decompressedData!)
    }
    
    public static func GetHardwareModel() -> String
    {
        var modelName: String {

            #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
            #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8 , value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            #endif

            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            default:                                        return identifier
            }
        }

        return modelName
    }

    
    public static func GetHardwareID() -> UUID
    {
        let uuID = UIDevice.current.identifierForVendor
        return uuID!
    }
    public static func GetNextRandomPositiveInt32() -> Int32
    {
        return Int32.random(in: 1 ..< Int32.max)
    }
    
    public static func UuidFromObjectNode(_ node : Document, _ key : String) -> UUID
    {
        let bytes = (node.get(key) as! BSON.Binary).data
        let uuidt = uuid_t(bytes[3], bytes[2], bytes[1], bytes[0], bytes[5], bytes[4], bytes[7], bytes[6], bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15])
        return UUID.init(uuid: uuidt)
    }

    
    public static func UuidToGuidByteArray(_ uuid : UUID) -> [UInt8]
    {
        var data: Data { return withUnsafeBytes(of: uuid, { Data($0) }) }
        var bytes = [UInt8](data)
        
        var x : UInt8
        x = bytes[0]; bytes[0] = bytes[3]; bytes[3] = x
        x = bytes[1]; bytes[1] = bytes[2]; bytes[2] = x

        x = bytes[4]; bytes[4] = bytes[5]; bytes[5] = x
        x = bytes[6]; bytes[6] = bytes[7]; bytes[7] = x

        return bytes
    }
    
    public static func MessageToBsonBytes(_ message : FleetMessage) -> [UInt8]?
    {
        let node = message.ToObjectNode()
        if (node == nil)
        {
            return nil
        }

        let data:[UInt8] = node!.bytes
        return data
    }

    
    public static func Int16ToByteArray(_ value : Int16) -> [UInt8]
    {
        return value.twoBytes
    }

    public static func Int32ToByteArray(_ value : Int32) -> [UInt8]
    {
        return value.fourBytes
    }
    static func Random(min: UInt32, max: UInt32) -> UInt32 {
        return arc4random_uniform(UInt32(max - min)) + min
    }
    public static func ArrayCopy(_ src : [UInt8], _ srcPos : Int, _ dest : inout [UInt8], _ destPos : Int, _ length : Int) -> Void
    {
        dest.replaceSubrange(destPos ..< destPos + length, with: src[srcPos ..< srcPos + length])
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
    
    public static func MessageToBsonBytes(_ message : FleetMessage) -> [UInt8]?
    {
        let node = message.ToObjectNode()
        if (node == nil)
        {
            return nil
        }

        let data:Bytes = node!.bytes
        return data
    }

}

extension Int16
{
    var twoBytes : [UInt8]
    {
        let unsignedSelf = UInt16(bitPattern: self)
        return [UInt8(truncatingIfNeeded: unsignedSelf),
                UInt8(truncatingIfNeeded: unsignedSelf >> 8)]
    }
}

extension Int32
{
    var fourBytes : [UInt8]
    {
        let unsignedSelf = UInt32(bitPattern: self)
        return [UInt8(truncatingIfNeeded: unsignedSelf),
                UInt8(truncatingIfNeeded: unsignedSelf >> 8),
                UInt8(truncatingIfNeeded: unsignedSelf >> 16),
                UInt8(truncatingIfNeeded: unsignedSelf >> 24)]
    }
}
extension UUID
{
    static var Empty : UUID
    {
        return UUID.init(uuidString: "00000000-0000-0000-0000-000000000000")!
    }
}

extension Document
{
    mutating func set(_ key : String, _ value : Document) -> Void
    {
        self.append(value)
    }
    mutating func put(_ key : String, _ value : Primitive) -> Void
    {

        if (value is [UInt8])
        {
            let binary = Binary(data: value as! [UInt8], withSubtype: BSON.Binary.Subtype.generic)
            self.append(binary, forKey: key)
            return
        }


        self.append(value, forKey: key)
    }
    func has(_ key : String) -> Bool
    {
        return self[key] != nil
    }

    func get(_ key : String) -> Primitive
    {
        return self[key]!
    }
    public func ObjectList(_ key : String) -> Array<Document>?
    {
        let document = self[key] as? Document
        if (document == nil)
        {
            return nil
        }
        
        let objectList = document!.map { (k, v) in return v as! Document }
        return objectList
    }
    
    mutating public func CreateArrayNode() -> Document
    {
        let doc = Document(array: [Primitive?]())
        return doc
    }
}
extension Primitive
{
    func asText() -> String
    {
        return self as! String
    }
    func asInt64() -> Int64
    {
        if (self is Int64)
        {
            return self as! Int64
        }
        
        return Int64(self as! Int)
    }
    func asInt32() -> Int32
    {
        if (self is Int32)
        {
            return self as! Int32
        }
        
        return Int32(self as! Int)
    }
    func asInt() -> Int
    {
        if (self is Int)
        {
            return self as! Int
        }
        
        return Int(self as! Int32)
    }
    func asFloat() -> Float
    {
        return self as! Float
    }
    func asDouble() -> Double
    {
        return self as! Double
    }
    func asBytes() -> [UInt8]
    {
        return [UInt8]((self as! BSON.Binary).data)
    }
    func asDateTime() -> Date
    {
        return Date(timeIntervalSince1970: Double(self.asInt64()) / 1000.0)
    }
}
public enum FleetError : Error
{
    case General(reason : String)
}
extension Data
{
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    var md5: Data {
        var digest = [Byte](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_MD5($0, CC_LONG(self.count), &digest)
        })
        return Data(bytes: digest, count: 1)
    }
    
    var sha1: Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_SHA1($0, CC_LONG(self.count), &digest)
        })
        return Data(bytes: digest)
    }
    
    var sha256: Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_SHA256($0, CC_LONG(self.count), &digest)
        })
        return Data(bytes: digest)
    }
}

extension NSObject
{
    func synchronized(lockObj: AnyObject!, closure: () throws -> Void) rethrows
    {
        objc_sync_enter(lockObj)
        defer { objc_sync_exit(lockObj) }
        try closure()
    }
    
    func synchronized<T>(lockObj: AnyObject!, closure: () throws -> T) rethrows ->  T
    {
        objc_sync_enter(lockObj)
        defer { objc_sync_exit(lockObj) }
        return try closure()
    }
}
