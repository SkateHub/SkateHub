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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioLabel: UITextView!
    var user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfileImage()
        bioLabel.text=user!["bio"] as! String
        
    }
    
    func updateProfileImage(){
        if let user = PFUser.current(){
            let image=user["profileImage"] as! PFFileObject
            let urlString=image.url!
            let url=URL(string: urlString)!
            profileImage.af_setImage(withURL: url)
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let login=main.instantiateViewController(withIdentifier: "loginView")
        let scene=self.view.window?.windowScene?.delegate  as! SceneDelegate
        scene.window?.rootViewController=login
    }
    @IBAction func onEditImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var currentImage: UIImage!
        let image = info[.editedImage] as! UIImage
        currentImage = image
        
        if let user = PFUser.current(){
            let profileData=currentImage.pngData()
            let imageFile=PFFileObject(name: "profileImage.png", data: profileData!)
            user["profileImage"]=imageFile
            user.saveInBackground()
            dismiss(animated: true, completion: nil)
        }
        
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