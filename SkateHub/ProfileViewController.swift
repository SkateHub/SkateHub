//
//  ProfileViewController.swift
//  SkateHub
//
//  Created by Paola Camacho on 4/2/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioLabel: UITextView!
    var user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image=user!["profileImage"] as! PFFileObject
        let urlString=image.url!
        let url=URL(string: urlString)!
        profileImage.af_setImage(withURL: url)
        bioLabel.text=user!["bio"] as! String
        

        
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
