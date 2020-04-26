//
//  SignUpViewController.swift
//  SkateHub
//
//  Copyright © 2020 Jose Patino/Aldo Almeida/Paola Camacho All rights reserved.
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
        self.navigationController?.setNavigationBarHidden(false, animated: false)  
        super.viewDidLoad()
    }
    
    @IBAction func onSignUp(_ sender: Any)
    {
        let  user = PFUser()
        
        user["FirstName"] =  firstNameField.text
        user["LastName"] = lastNameField.text
        let profileData=#imageLiteral(resourceName: "default-profile").pngData()
        let imageFile=PFFileObject(name: "profileImage.png", data: profileData!)
        user["profileImage"]=imageFile
        user["bio"]="Welcome to my profile!"
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
                    self.performSegue(withIdentifier: "signupDone", sender: nil)
                }
                else
                {
                    print("Error: \(error?.localizedDescription)")
                }
            }
        }

    }
}
