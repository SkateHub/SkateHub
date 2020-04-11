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

class ProfileFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

    var posts = [PFObject]()
    
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        
        
        if let user = PFUser.current()
        {
            //Set the profile pic
            let profileImage = user["profileImage"] as! PFFileObject
            guard  let urlString  =  profileImage.url else { return}
            let url = URL(string: urlString)!
            profilePictureImageView.af_setImage(withURL: url)
            
            //Set the bio
            bioLabel.text = user["bio"] as? String
            
            //Set  the  user's name
            let userFirstName = user["FirstName"] as! String
            let userLastName = user["LastName"] as! String
            nameOfUserLabel.text = "\(userFirstName) \(userLastName)"
            
            self.currentUser = user
            
            
        }
        reloadInputViews()
        self.postCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "image"])
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil
            {
                
                self.posts = posts!
                self.postCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let post = posts[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostGridCell", for: indexPath) as! PostGridCell
        let user = post["author"] as! PFUser
        let currentUser = PFUser.current()
        
        //issue lies in the condition of the If statment, other than that, it works
        
        if user == currentUser
        {
            print("got here")
            let postPicture = post["image"] as! PFFileObject
            let urlString  =  postPicture.url!
            let url = URL(string: urlString)!
            cell.postPicture.af_setImage(withURL: url)
            
        }
        
        return cell
    }
    


}
