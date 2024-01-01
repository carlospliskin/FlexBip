//
//  Event.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 07/12/21.
//

import Foundation

public class Event {
    
    private static let TAG : String = "Event"

    var _lockObject : NSLock = NSLock()
    var subscribers = [EventListener]()
    
    public func AddListener(_ subscriber : EventListener) -> Void
    {
        _lockObject.lock()
        
        subscribers.append(subscriber)
        
        _lockObject.unlock()
    }
}
