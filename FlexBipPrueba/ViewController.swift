//
//  ViewController.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 15/12/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, EventListener {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var UserNameTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var ServerAddressTxt: UITextField!
    
    var fleetClientSystem : FleetClientSystem!
    var imagePicker :UIImagePickerController!
    var keyboardShift: CGFloat = 0
    var popUpVC : LoginProgressController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UserNameTxt.text = "5563490703"
        PasswordTxt.text = "Demo001"
        ServerAddressTxt.text = "flexbip.com"
        
        FleetClientSystem.loginEvent.AddListener(self)
        
        Settings.Update()
    }
    
    @IBAction func LoginBtn(_ sender: Any)
    {
        Settings.Set(UserNameTxt.placeholder, "UserName")
        Settings.Set(PasswordTxt.placeholder, "Password")
        Settings.Set(ServerAddressTxt.text, "ServerAddress")

        fleetClientSystem =  FleetClientSystem()

        popUpVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginProgressPopup") as! LoginProgressController)
        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParent: self)

        fleetClientSystem.Start(login: UserNameTxt.text!, password: PasswordTxt.text!, serverAddress: ServerAddressTxt.text!)
    }


    func OnEvent(_ sender: AnyObject, _ eventArgs: Any?) throws {
        
    }
}

