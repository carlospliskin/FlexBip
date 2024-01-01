//
//  FleetData.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 15/12/21.
//

import Foundation
import BSON

public class FleetData
{
    
    var _fleetClient : FleetClient

    public var clients = ConcurrentInitializableDictionary<FleetClientData>()
    public var users = ConcurrentInitializableDictionary<FleetUser>()
    public var dataListener : FleetDataListener?
    

    public init(_ client : FleetClient)
    {
        _fleetClient = client
    }
    public func AddDataListener(_ listener : FleetDataListener) -> Void
    {
        dataListener = listener
    }

    public func Clear()
    {
        
    }

    
    
}
