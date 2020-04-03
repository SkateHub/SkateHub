//
//  logInViewController.swift
//  SkateHub
//
//  Created by Jose Patino on 3/5/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)  
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        let username=usernameField.text!
        let password=passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password){(user,error) in
            if(user != nil){
                self.performSegue(withIdentifier: "loginDone", sender: nil)
            }
            else{
                print("Error:\(error?.localizedDescription)")
            }
        }
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

