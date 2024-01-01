//
//  FleetConnector.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 09/12/21.
//

import Foundation
import Network

public class FleetConnector
{
    var _address : String
    var _port : Int

    var isClosing : Bool = false
    var _lockObject : NSLock = NSLock()
    var _client : FleetClient!

    var inputStream : InputStream!
    var outputStream : OutputStream!

    public init(_ fleetClient : FleetClient, _ address : String, _ port : Int)
    {
        _client = fleetClient
        _address = address
        _port = port
    }
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event)
    {
        print("stream event \(eventCode)")
    }

    public func Connect() throws -> FleetSocket?
    {
        _lockObject.lock()

        isClosing = false
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, _address as CFString, UInt32(_port), &readStream, &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()

        inputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.common)
        outputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.common)
        
        let dict = Dictionary<String, Bool>(dictionaryLiteral: (kCFStreamSSLValidatesCertificateChain as String, false))
        inputStream.setProperty(StreamSocketSecurityLevel.negotiatedSSL, forKey: Stream.PropertyKey.socketSecurityLevelKey)
        inputStream.setProperty(dict, forKey: kCFStreamPropertySSLSettings as Stream.PropertyKey)
        
        inputStream.open()
        outputStream.open()
//Error
        while (!isClosing && inputStream.streamStatus == .opening)
        {
            sleep(1)
        }

        if (inputStream.streamStatus != .open)
        {
            _lockObject.unlock()
            inputStream.close()
            outputStream.close()
            return nil
        }
        
        _lockObject.unlock()

        return FleetSocket(inputStream, outputStream)
    }

    func Stop() throws -> Void
    {
        isClosing = true

        _lockObject.lock()

        Break()

        _lockObject.unlock()
    }

    public func Break()
    {
        isClosing = true
        inputStream?.close()
        outputStream?.close()
    }
    
    private func urlToIP(_ address:String) -> String? {
        
        guard let host = address.withCString({gethostbyname($0)}) else {
            return nil
        }
        
        guard host.pointee.h_length > 0 else {
            return nil
        }
        
        var addr = in_addr()
        memcpy(&addr.s_addr, host.pointee.h_addr_list[0], Int(host.pointee.h_length))
        
        guard let remoteIPAsC = inet_ntoa(addr) else {
            return nil
        }
        
        return String.init(cString: remoteIPAsC)
    }

    func createCertificateFromFile(filename: String, ext: String) -> SecCertificate
    {
        let rootCertPath = Bundle.main.path(forResource:filename, ofType: ext)
        let rootCertData = NSData(contentsOfFile: rootCertPath!)
        return SecCertificateCreateWithData(kCFAllocatorDefault, rootCertData!)!
    }
    
    func addAnchorToTrust(trust: SecTrust, certificate: SecCertificate) -> OSStatus
    {
        let array: NSMutableArray = NSMutableArray()
        array.add(certificate)
        return SecTrustSetAnchorCertificates(trust, array)
    }

}
