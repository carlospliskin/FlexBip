//
//  LoginProgressController.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 15/12/21.
//

import Foundation
import UIKit

class LoginProgressController: UIViewController
{
    @IBOutlet weak var ContainerView: UIView!
    /*@IBAction func CancelBtnTap(_ sender: Any)
    {
        FleetClientSystem.activeClient?.Stop()
        self.view.removeFromSuperview()
    }*/
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       
    }

    public func Close()
    {
        self.view.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
