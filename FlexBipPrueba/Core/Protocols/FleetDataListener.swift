//
//  FleetDataListener.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 14/12/21.
//

import Foundation

public protocol FleetDataListener
{
    func OnAvatarChanged(_ hash : String, _ avatar : [UInt8])
    func OnLogoChanged(_ hash : String, _ logo : [UInt8])
}
