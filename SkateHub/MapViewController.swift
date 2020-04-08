//
//  MapViewController.swift
//  SkateHub
//
//  Created by Aldo Almeida on 4/8/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    let mapManager=CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceCheck()
        // Do any additional setup after loading the view.
    }
    
    func serviceCheck(){
        if(CLLocationManager.locationServicesEnabled()){
            checkAuthorization()
            
            } else{
            
        }
    }
    
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation=true
        case .denied:
            break
        case .notDetermined:
            mapManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation=true
        case .restricted:
            break
        case .authorizedAlways:
            break
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
