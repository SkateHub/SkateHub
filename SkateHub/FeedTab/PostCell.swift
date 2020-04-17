//
//  PostCell.swift
//  SkateHub
//
//  Created by Paola Camacho on 4/3/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
