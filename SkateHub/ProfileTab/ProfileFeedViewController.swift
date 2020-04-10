//
//  ProfileFeedViewController.swift
//  SkateHub
//
//  Created by Jose Patino on 4/8/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class ProfileFeedViewController: UIViewController
{

    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let user = PFUser.current()
        {
            //Set the profile pic
            let profileImage = user["profileImage"] as! PFFileObject
            guard  let urlString  =  profileImage.url else { return}
            let url = URL(string: urlString)!
            profilePictureImageView.af_setImage(withURL: url)
            
            let profileImage2 = user["bgImage"] as! PFFileObject
            guard  let urlString2  =  profileImage2.url else { return}
            let url2 = URL(string: urlString2)!
            backgroundImageView.af_setImage(withURL: url2)
            
            //Set the bio
            bioLabel.text = user["bio"] as? String
            
            //Set  the  user's name
            let userFirstName = user["FirstName"] as! String
            let userLastName = user["LastName"] as! String
            nameOfUserLabel.text = "\(userFirstName) \(userLastName)"
        }
        reloadInputViews()
    }
    
    
    

}
