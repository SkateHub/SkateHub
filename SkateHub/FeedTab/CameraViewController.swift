//
//  CameraViewController.swift
//  SkateHub
//
//  Created by Paola Camacho on 4/8/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import Parse
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    var retrievePhoto:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image=retrievePhoto
    }
    
    @IBAction func onPostButton(_ sender: Any) {
        self.postBtn.isEnabled=false
        let post = PFObject(className: "Posts")
        
        post["caption"] = captionField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground(block: { (success, error) in
            if success{
                self.postBtn.isEnabled=true
                print("Saved!")
                self.performSegue(withIdentifier: "done", sender: nil)
            }else{
                self.postBtn.isEnabled=true
                print("Error!")
            }

            
        })
        
    }


}
