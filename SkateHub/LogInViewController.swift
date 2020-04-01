//
//  logInViewController.swift
//  SkateHub
//
//  Created by Jose Patino on 3/5/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)  
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "feed", sender: nil)
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
