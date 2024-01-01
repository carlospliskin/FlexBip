//
//  FleetCommandProcessor.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 16/12/21.
//

import Foundation

public class FleetCommandProcessor
{
    var isClosing : Bool = false
    var _lockObject : NSLock = NSLock()
    var _inputMessageQueue : FleetMessageQueue

    public init(inputMessageQueue : FleetMessageQueue)
    {
        _inputMessageQueue = inputMessageQueue
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

}
