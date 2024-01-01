//
//  FleetClientListener.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 14/12/21.
//

import Foundation

public protocol FleetClientListener
{
    func OnLogin(_ status : Bool, _ details : String)
    func OnDataChanged(_ dataItem : Any?, _ dataObject : Any?, _ dataType : FleetDataType, _ op : DataOps)
    func OnQueryData(_ dataItem : Any?, _ dataObject : Any?, _ dataType : FleetDataType, _ op : DataOps)
    
}
