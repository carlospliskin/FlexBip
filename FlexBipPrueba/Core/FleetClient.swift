//
//  fleetClienet.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 09/12/21.
//

import Foundation
import Network

public class FleetClient 
{
    
    private static let TAG : String = "FleetClient"
    public var verbose : Bool = false
    
    public var DeviceID : UUID!
    public var UserID : UUID!
    private var _connectionData : ConnectionData
    private var _commandProcessor : FleetCommandProcessor!
    private var _commandReader : FleetCommandReader!
    private var _commandSender : FleetCommandSender!
    /*
     
    private var _commandReader : FleetCommandReader!
    private var _commandSender : FleetCommandSender!
    private var _commandProcessor : FleetCommandProcessor!
    
    */
    
    private var _inputMessageQueue : FleetMessageQueue
    private var _outputMessageQueue : FleetMessageQueue
    private var _lockObject : NSLock = NSLock()
    private var _connector : FleetConnector!
    public var Socket : FleetSocket!
    private var _dispatchQueue : DispatchQueue
    
    /*public var fleetStorage : FleetStorage!
    public var fleetData : FleetData!
    public var fleetCalls : FleetCalls!
    public var fleetGPS : FleetGPS!*/

    
    public static var Login : String = ""
    public static var Password : String = ""
    public var LogoHash : String = ""
    public var versionName : String!
    public var SSRC : UInt32!
    public var AvatarHash : String? = nil
    public var Encryption : Bool = false
    public var AllowedOps : Int = 0
    private var isLoggedOn : Bool = false
    public var DebugLog : Bool = false
    private var isClosing : Bool = false
    
    public var ViceEncrypted : Bool = false;
    public var EncryptionKey : [UInt8]?
    var _aesEncrypter : AesEncryptor?;
    
    public init(_ deviceID : UUID, _ connectionData : ConnectionData)
    {
        DeviceID = deviceID
        _connectionData = connectionData

        _inputMessageQueue = FleetMessageQueue()
        _outputMessageQueue = FleetMessageQueue()

        _dispatchQueue = DispatchQueue.init(label: "clientQueue")
        _connector = FleetConnector(self, connectionData.serverAddress, connectionData.serverCommandPort)

       SSRC = UInt32(Utils.GetNextRandomPositiveInt32())
        

        do { _aesEncrypter = try AesEncryptor(bufferSize: 1024) }
        catch {}
        
    }
    
    public func OnMessage(_ message : FleetMessage) throws -> Void
    {


        switch (message.CommandType)
        {
            case .SERVER_CONFIG:
                let config = message as! ConfigMessage
                OnSessionConfigure(config: config)
                
                print("conexion exitosa")
                
                
                break
        
        case .UNKNOWN:
            
            break
        }
    
    
    //MARK: - SERVER
    
}
    
    func Start() -> Void
    {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        if let avatarUrl = documentsPath?.appendingPathComponent("wfavatar.jpg")
        {
            if fileManager.fileExists(atPath: avatarUrl.path)
            {
               
            }
        }
        
        _dispatchQueue.async
        {
            self._lockObject.lock()
            
            Logger.v(FleetClient.TAG, "connecting to \(self._connectionData.serverAddress):\(self._connectionData.serverCommandPort) ...")
            
            self.isClosing = false
            self.InternalStart()
            
            self._lockObject.unlock()
        }
        
      
        
    }
    private func InternalStart()
    {
        do
        {
            if (_commandProcessor != nil)
                { return }
            
            repeat
            {
                try Socket = _connector.Connect()
            } while (Socket == nil) && !isClosing
            
            if (Socket ==  nil)
                { return }
            
            Logger.v(FleetClient.TAG, "command socket connected")
            
            print ("se rompe ")

            _commandSender = FleetCommandSender(outputStream: Socket!.OutputStream, _outputMessageQueue)
            _commandReader = FleetCommandReader(self, _inputMessageQueue)
            _commandProcessor = FleetCommandProcessor(inputMessageQueue: _inputMessageQueue)
                //SE CONECTA EL SOCKET _CONNECTIONData
            _commandReader.Start()
        }
        catch
        {
           /* Logger.e(FleetClient.TAG, "\(#function) failed -  \(error)")
            CloseRtpContext();
 */
        }
        
        _lockObject.unlock()
    }
    
    func OnSessionConfigure(config : ConfigMessage) -> Void
    {
        _lockObject.lock()

        do
        {
            Codec.ReleaseCodec()
           // Codec.SetCodecParameters(audioSampleRate: Int(config.AudioSampleRate), audioBitRate: Int(config.AudioBitRate), frameSizeInMs: Int(config.AudioFrameSize))
           // _codec = Codec.GetCodec()

            UpdateConnectionData(config)
            //CloseRtpContext()
            //try CreateRtpContext()

            //workerListener?.OnEvent(self, "Connected")
            
            
//            if (workerListener != null)
//            workerListener.OnEvent(this, "Connected");

           /* let userName = FleetClient.Login
            let userPassword = FleetClient.Password

            let appName = "Client for iOS"
            let statusID = UUID.Empty
            let versionCode : Int = 1
*/

            DeviceID = Utils.GetHardwareID()
           // GetVersion()

            //let deviceConfig = ConfigMessage(deviceID: DeviceID, statusID: statusID, SSRC: SSRC, appName: appName, versionCode: versionCode, versionName: versionName, userName: userName, userPassword: userPassword, deviceDescription: deviceDescription, avatarHash: AvatarHash)
//            fillApkJobResponseIfAny(deviceConfig);
           // SendFleetMessage(deviceConfig);

//            soundReceiver.Start("SoundReceiver");
//            videoReceiver.Start("VideoReceiver");
        }
        catch
        {
           // Logger.e(FleetClient.TAG, "\(#function) failed -  \(error)")
           // CloseRtpContext();
        }

        _lockObject.unlock()
    }//
    
    private func UpdateConnectionData(_ serverConfig : ConfigMessage)
    {
//        connectionData.serverAddress = clientConnector.activeConnector.ServerAddress;
        _connectionData.serverVOIPPort = serverConfig.ServerVoipPort
        _connectionData.serverVideoPort = serverConfig.ServerVideoPort
//        _connectionData.localVOIPPort = serverConfig.LocalMediaPort
//        _connectionData.localVideoPort = serverConfig.LocalMediaPort + 1
    }
    
    func CloseRtpContext() -> Void
    {
        
        

    }//CLOSERTPCONTEXT
    
    

}
