//
//  FleetCommandReader.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 16/12/21.
//


import Foundation

public class FleetCommandReader
{
    private static let TAG : String = "FleetCommandReader"
    
    var isClosing : Bool = false
    var _lockObject : NSLock = NSLock()
    var _inputMessageQueue : FleetMessageQueue
    var _client : FleetClient!
    var _socket : FleetSocket!
    var _inputStream : InputStream
    
    var _headerBuffer = [UInt8](repeating: 0, count: 4)
    var _buffer = [UInt8](repeating: 0, count: 1024)
    var _internalStream : OutputStream
    var _internalStreamLen : Int = 0
    var _dispatchQueue : DispatchQueue
    
    
    public init(_ fleetClient : FleetClient, _ inputMessageQueue : FleetMessageQueue)
    {
        _client = fleetClient
        _socket = _client.Socket
        _inputStream = _socket.InputStream
        _inputMessageQueue = inputMessageQueue
        
        _internalStream = OutputStream.toMemory()
        _internalStream.open()
        
        _dispatchQueue = DispatchQueue.init(label: "commandReaderQueue")
    }
    
    private func Read(_ buffer: inout [UInt8], _ count : Int) -> Int
    {
        if (_inputStream.streamError != nil)
        {
            return -1
        }

        switch _inputStream.streamStatus
        {
            case .notOpen, .atEnd, .closed, .error:
                return -1
            default:
                break
        }
        
        let bytesRead = _inputStream.read(&buffer, maxLength: count)
        return bytesRead
    }
    
    public func ReadMessage() throws -> FleetMessage?
    {
        repeat
        {
            _headerBuffer = [UInt8]()
            repeat
            {
                let bytesRead = Read(&_buffer, 4 - _headerBuffer.count)
                if (bytesRead < 0)
                {
                    return nil
                }
                if (bytesRead > 0)
                {
                    _headerBuffer.append(contentsOf: _buffer[0 ..< bytesRead])
                }
            } while _headerBuffer.count != 4
            
            let dataSize = Int(Utils.parseInt32(bytes: _headerBuffer, offset: 0)) - 4
            _internalStream = OutputStream.toMemory()
            _internalStream.open()
            _internalStreamLen = 0
            
            repeat
            {
                var bytesToRead = dataSize - _internalStreamLen
                if (bytesToRead > _buffer.count)
                    { bytesToRead = _buffer.count }
                
                let bytesRead = Read(&_buffer, bytesToRead)
                if (bytesRead < 0)
                {
                    return nil
                }
                if (bytesRead > 0)
                {
                    _internalStream.write(&_buffer, maxLength: bytesRead)
                    _internalStreamLen += bytesRead
                }
            } while _internalStreamLen < dataSize

            let data: Data = _internalStream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
            return FleetMessage.Parse(data: data)
        } while true
    }
    
    func Run() -> Void
    {
        do
        {
            repeat
            {
                let message = try ReadMessage()
                if (message == nil)
                {
                    return
                }
               //else {  try _client.OnMessage(message!) }
                
            } while true
        }
        catch
        {
            //Logger.e(FleetCommandReader.TAG, "\(#function) failed -  \(error)")
        }
    }
    
    func Start() -> Void
    {
        _lockObject.lock()
        
        isClosing = false

        _dispatchQueue.async
        {
            self.Run()
            //self._client.OnDisconnected()
        }
        
        _lockObject.unlock()
    }
    
    func Stop() throws -> Void
    {
        _lockObject.lock()
        
        isClosing = true
        
        _lockObject.unlock()
    }
    
}


