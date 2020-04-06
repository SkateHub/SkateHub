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
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    var isProfilePic:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius=profileImage.frame.height/2
        profileImage.clipsToBounds=true
        profileImage.layer.borderColor=UIColor.systemPink.cgColor
        profileImage.layer.borderWidth=2
        updateBtn.layer.cornerRadius=6
        logBtn.layer.cornerRadius=6
        deleteBtn.layer.cornerRadius=6
        bioLabel.layer.cornerRadius=2
        bioLabel.layer.borderColor=UIColor.systemPink.cgColor
        bioLabel.layer.borderWidth=0.5
        updateProfileImage()
        updateBgImage()
        bioLabel.text=PFUser.current()!["bio"] as! String
        self.view.layoutIfNeeded()
        
    }
    
    func updateProfileImage(){
        if let user = PFUser.current(){
            let image=user["profileImage"] as! PFFileObject
            guard let urlString=image.url else { return }
            let url=URL(string: urlString)!
            profileImage.af_setImage(withURL: url)
        }
    }
    
    func updateBgImage(){
        if let user = PFUser.current(){
            if user["bgImage"] != nil{
                let image=user["bgImage"] as! PFFileObject
                guard let urlString=image.url else { return }
                let url=URL(string: urlString)!
                bgImage.af_setImage(withURL: url)
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main=UIStoryboard(name: "Main", bundle: nil)
        let login=main.instantiateViewController(withIdentifier: "loginView")
        let scene=self.view.window?.windowScene?.delegate  as! SceneDelegate
        scene.window?.rootViewController=login
    }
    @IBAction func onEditBG(_ sender: Any) {
        isProfilePic=false
        imagePicker()
    }
    @IBAction func onEditImage(_ sender: Any) {
        isProfilePic=true
        imagePicker()
    }
    
    func imagePicker(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        var currentImage: UIImage!
        let image = info[.editedImage] as! UIImage
        currentImage = image
        
        if let user = PFUser.current(){
            if(isProfilePic){
                let profileData=currentImage.pngData()
                let imageFile=PFFileObject(name: "profileImage.png", data: profileData!)
                user["profileImage"]=imageFile
                user.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateProfileImage()
                    }
                })
                dismiss(animated: true, completion: nil)
            } else{
                let profileData=currentImage.pngData()
                let imageFile=PFFileObject(name: "bg.png", data: profileData!)
                user["bgImage"]=imageFile
                user.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateBgImage()
                    }
                })
                dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func onUpdateBio(_ sender: Any) {
        if(bioLabel.text.count < 30){
            if let user=PFUser.current(){
                user["bio"] = bioLabel.text
                user.saveInBackground()
                let alert=UIAlertController(title: "Bio updated", message: "Your bio has been updated!", preferredStyle: UIAlertController.Style.alert)
                let alertAction=alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            let alert=UIAlertController(title: "Shorten bio", message: "Bio must be less than 30 characters!", preferredStyle: UIAlertController.Style.alert)
            let alertAction=alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func onDeleteAccount(_ sender: Any) {
        if let user=PFUser.current(){
            user.deleteInBackground()
            let main=UIStoryboard(name: "Main", bundle: nil)
            let login=main.instantiateViewController(withIdentifier: "loginView")
            let scene=self.view.window?.windowScene?.delegate  as! SceneDelegate
            scene.window?.rootViewController=login
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
