//
//  addSpotView.swift
//  SkateHub
//
//  Copyright © 2020 Jose Patino/Aldo Almeida/Paola Camacho All rights reserved.
//

import UIKit

class addSpotView: UIView {
    @IBOutlet weak var spotBtn: UIButton!
    @IBOutlet weak var spotLabel: UITextView!
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet var viewSpot: UIView!
    let nibName="addSpot"
    
    
    @IBAction func onSubmit(_ sender: Any) {
        print("worked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: nibName, bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(viewSpot)
        viewSpot.frame=self.bounds
    }
    
  
    /*
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
