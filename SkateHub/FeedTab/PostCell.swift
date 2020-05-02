//
//  PostCell.swift
//  SkateHub
//
//  Copyright © 2020 Jose Patino/Aldo Almeida/Paola Camacho All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    var postID:String!
    var user:PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // loadPost()
        //likeBttn.setTitle("🤙", for: .normal)
        postImage.layer.cornerRadius=6
        postImage.layer.borderColor=UIColor.black.cgColor
        postImage.layer.borderWidth=1
        
    }

    @IBOutlet weak var likeBtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
