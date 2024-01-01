//
//  FleetCommandSender.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 16/12/21.
//

import Foundation


public class FleetCommandSender
{
    let COMMANDHEADERSIZE : Int = 8;
    let DATAHEADERSIZE : Int = 5;


    var isClosing : Bool = false
    var _lockObject : NSLock = NSLock()
    var _outputMessageQueue : FleetMessageQueue
    var _outputStream : OutputStream
    var  delayed = Queue<FleetMessage>()

    public init(outputStream : OutputStream, _ outputMessageQueue : FleetMessageQueue)
    {
        _outputMessageQueue = outputMessageQueue
        _outputStream = outputStream
    }
    
    func Start() -> Void
    {
        _lockObject.lock()
        
/*
        do
        {
            
        }
        catch
        {
            
        }
*/

        _lockObject.unlock()
    }
    
    func Stop() throws -> Void
    {
        _lockObject.lock()
        
/*
        do
        {
            
        }
        catch
        {
            
        }
*/

        _lockObject.unlock()
    }

    public func SendMessage(_message : FleetMessage) -> Void
    {
        _lockObject.lock()
        //let data = Utils.MessageToBsonBytes(message)
        var packetSize = COMMANDHEADERSIZE
        
    }
    public func AddDelayed(_ message : FleetMessage ) -> Void
    {
        delayed.enqueue(message)
        if (delayed.count > 1000)
            { delayed.remove() }
    }
}
