//
//  LoginEventArgs.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 08/12/21.
//

import Foundation

public class LoginEventArgs {
    
    public var success : Bool = false
    public var details : String
    
    public init(_ status : Bool, _ details : String){
        success = status
        self.details = details
    }
}
