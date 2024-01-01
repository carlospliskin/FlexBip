//
//  Settings.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 07/12/21.
//

import Foundation

public class Settings {
    
    public static var lastLoginUserName : String? = nil
    public static var lastLoginUserPassword : String? = nil
    public static var lastLoginServerAddres : String? = nil

    public static var lastStatusID : UUID? = UUID.init()
    public static var selectedGroupID = UUID.Empty
    public static var autoLogin : Bool = false
    /*
    
        
    
    
    
    //---------
    public static var serverMapSystem : Int = 0
    public static var customOSM_URL : String = ""

    public static var useCustomLogo : Bool = false
    public static var hideDemoLink : Bool = false
    public static var enableAllowedServers : Bool = false
    public static var allowedServers : String?
    public static var ignoreServerSettings : Bool = false
    
    
    //-----
    public static var preventCPUsleep_server : Int = 0
    
    public static var videoResolution_server : Int = 0
    public static var defaultPTTGroup : String = ""
    
    public static var setDefaultGroupSelected : Bool = true
    */
    
    public static func Update()
    {
        let defaults = UserDefaults.standard

        lastLoginUserName = defaults.string(forKey: "UserName")
        lastLoginUserPassword = defaults.string(forKey: "Password")
        lastLoginServerAddres = defaults.string(forKey: "ServerAddress")
        lastStatusID = UUID(uuidString: defaults.string(forKey: "StatusID") ?? UUID.Empty.uuidString)
        selectedGroupID = UUID(uuidString: defaults.string(forKey: "SelectedGroup") ?? UUID.Empty.uuidString)!
        autoLogin = defaults.bool(forKey: "pref_autologin")
       
    }
    public static func Set(_ value : Any?, _ key : String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }


}
