//
//  FleetMessages.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 13/12/21.
//

import Foundation
import CoreLocation
import BSON

public class ConfigMessage : FleetMessage
{
    public var ServerVoipPort : Int!
    public var ServerVideoPort : Int!
    public var LocalMediaPort : Int!
    public var CodecID : Int!
    public var AudioBitRate : Int!
    public var AudioSampleRate : Int!
    public var AudioFrameSize : Int! // in msec

    public var clientData : FleetClientData!
    public var Password : String!
    public var Ssrc : Int!
    public var AppName : String!
    public var VersionCode : Int!
    public var VersionName : String!
    public var UpdateJobID : UUID?
    public var UpdateJobResult : Int?
    
    public override init(bytes : [UInt8])
    {
        super.init(bytes: bytes)
        
    }


    
}
public class SessionConfigResponseACK : FleetMessage
{
    public var Wellcome : String!
    public var UpdateVersionName : String!
    public var UpdateVersionSize : Int!
    public var Encryption : Bool!
    public var AllowedOps : Int!
    public var Result : UInt8!

    public init(result : UInt8)
    {
        super.init(commandType: .DEVICE_CONFIG, .FLAG_NONE)
        Result = result;
    }
    
    public init(_ jNode : Document)
    {
        super.init(commandType: .CONFIG_SERVER_RESPONSE_ACK);
        UpdateVersionName = jNode.get("UpdateVersionName").asText();
        UpdateVersionSize = jNode.get("UpdateVersionSize").asInt();
        Wellcome = jNode.get("Welcome").asText();
        Encryption = jNode.get("Encrypt").asInt() != 0;
        AllowedOps = jNode.get("AllowedOps").asInt();
    }
    
}


