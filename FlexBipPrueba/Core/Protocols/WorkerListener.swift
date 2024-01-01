//
//  WorkerListener.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 12/01/22.
//

import Foundation

public protocol WorkerListener
{
    func OnStart(_ worker : AnyObject, _success : Bool)
    
    func OnStop(_ worker : AnyObject, _ success : Bool)
    
    func OnEvent(_ sender : AnyObject, _ eventArgs: Any?)
}
