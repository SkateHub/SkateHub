//
//  PostCell.swift
//  SkateHub
//
//  Created by Paola Camacho on 4/3/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    var likedPosts = [String]()
    var postID:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadPost()
        
    }
    
    func loadPost(){
        if let user=PFUser.current(){
            do {
                try user.fetch()
                let posts=user["likedPosts"] as! Array<String>
                likedPosts=posts
            } catch  {
                print("ERROR")
            }
        }
        print(likedPosts,"\n SIZE IS \(likedPosts.count)")
    }

    @IBOutlet weak var likeBtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onLike(_ sender: Any) {
        likedPosts.append(postID)
        print(likedPosts)
        let user=PFUser.current()!
        user["likedPosts"]=likedPosts
        user.saveInBackground(block: { (success,errror) in
            if success{
                print("SAVED")
            } else{
                print("ERRPR")
            }
        })
    }
}
