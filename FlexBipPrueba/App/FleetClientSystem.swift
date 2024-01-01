//
//  FleetClientSystem.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 07/12/21.
//

import Foundation
import CallKit
import AVFoundation
import CoreLocation
import UserNotifications

public class FleetClientSystem : NSObject, FleetClientListener, CXCallObserverDelegate
{
    public func OnDataChanged(_ dataItem: Any?, _ dataObject: Any?, _ dataType: FleetDataType, _ op: DataOps) {
        
    }
    
    public func OnQueryData(_ dataItem: Any?, _ dataObject: Any?, _ dataType: FleetDataType, _ op: DataOps) {
        
    }
    
    
    
    
    public static var activeClient : FleetClient!
    
    public static var system : FleetClientSystem!
    private var fleetSocket : FleetSocket!
    private static var _lockObject = NSRecursiveLock()
    private static var _pttTimerLock : NSLock = NSLock()
    private static var _wfLock : NSLock = NSLock()
    private static var TAG : String = "FleetClientSystem"
    public static var loginEvent : Event = Event()
    public static var fleetData : FleetData!
    
    private var callListener : CXCallObserver!
    private var center : UNUserNotificationCenter!
    
    private static var network: NetworkManager = NetworkManager.sharedInstance
    
    //MARK: CallObserver
    
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        
    }
    
    
    func Start(login : String, password : String, serverAddress : String) -> Void
    {
        LogNetworkChange()
        
        let connectionData = ConnectionData()
        let srvaddr : [String] = serverAddress.components(separatedBy: ":")
        connectionData.serverAddress = srvaddr[0]
        connectionData.serverCommandPort = srvaddr.count == 1 ? 10000 : Int(srvaddr[1])!
        FleetClient.Login = login
        FleetClient.Password = password
        
        FleetDataManager.Initialize()
        FleetClientSystem.activeClient = FleetClient(UUID.init(uuidString: "00000000-0000-0000-0000-000000000001")!, connectionData)
        
        
       // FleetClientSystem.network.reachability.whenReachable = { _ in self.ProcessNetworkChange() }
        //FleetClientSystem.network.reachability.whenUnreachable = { _ in self.ProcessNetworkChange() }
    

       FleetClientSystem.activeClient.Start()
    }
    func Stop()
    {
       // FleetClientSystem.activeClient.Stop()
    }
    
    
    private func ProcessNetworkChange()
    {
        LogNetworkChange()
    }

    
    
    private func LogNetworkChange()
    {
        
    }
    public func OnLogin(_ status: Bool, _ details: String) {
        let client = FleetClientSystem.activeClient
        if (status && client != nil)
        {
//
        }

    }

    
    

}
