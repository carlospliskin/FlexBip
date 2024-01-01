//
//  EventListener.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 07/12/21.
//

import Foundation

public protocol EventListener {
    
    func OnEvent(_ sender : AnyObject, _ eventArgs : Any?) throws
}
