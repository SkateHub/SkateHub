//
//  FeedTableViewController.swift
//  SkateHub
//
//  Created by Paola Camacho on 4/3/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let profileBtn=UIButton(type: .custom)
    var barButton:UIBarButtonItem!
    var posts = [PFObject]()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        profileBtn.frame=CGRect(x: 0, y: 0, width: 40, height: 40)
        profileBtn.addTarget(self, action: #selector(editProfile(_:)), for: .touchUpInside)
        profileBtn.imageView?.contentMode = .scaleAspectFill
        profileBtn.clipsToBounds=true
        profileBtn.widthAnchor.constraint(equalToConstant: 40).isActive=true
        let image=getImage()
        profileBtn.af_setImage(for: .normal, url: image)
        barButton=UIBarButtonItem(customView: profileBtn)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        
    }
    
    
    @objc func editProfile(_ sender: UIButton){
        self.performSegue(withIdentifier: "editProfile", sender: nil)
    }
    
    func getImage() -> URL{
        let user = PFUser.current()!
        let image=user["profileImage"] as! PFFileObject
        let urlString=image.url!
        let url=URL(string: urlString)!
        return url
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.postImage.af_setImage(withURL: url)
        
        return cell
        
        
    }
    
    
    
    
    
}

