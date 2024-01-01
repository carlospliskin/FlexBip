//
//  FleetSocket.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 14/12/21.
//

import Foundation

public class FleetSocket : NSObject
{
    var InputStream : InputStream
    var OutputStream : OutputStream



    public init(_ inputStream : InputStream, _ outputStream : OutputStream)
    {
        InputStream = inputStream
        OutputStream = outputStream
    }

    public func Close()
    {
        InputStream.close()
        OutputStream.close()
    }

}
