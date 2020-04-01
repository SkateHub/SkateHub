//
//  SignUpViewController.swift
//  SkateHub
//
//  Created by Jose Patino on 3/5/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController
{

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onSignUp(_ sender: Any)
    {
        let  user = PFUser()
        
        user["FirstName"] =  firstNameField.text
        user["LastName"] = lastNameField.text
        user.username = usernameField.text
        user.password = passwordField.text
        
        if ((firstNameField.text != nil) &&
           (lastNameField.text != nil) &&
           (usernameField.text != nil) &&
           (passwordField.text != nil))
        {
            user.signUpInBackground { (success, error) in
                if success
                {
                    self.performSegue(withIdentifier: "feedSegue", sender: nil)
                }
                else
                {
                    print("Error: \(error?.localizedDescription)")
                }
            }
        }
        
    }
}
