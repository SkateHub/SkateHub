//
//  ProfileViewController.swift
//  SkateHub
//
//  Created by Paola Camacho on 4/2/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let login=main.instantiateViewController(withIdentifier: "loginView")
        let scene=self.view.window?.windowScene?.delegate  as! SceneDelegate
        scene.window?.rootViewController=login
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
