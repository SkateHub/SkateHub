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

    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var mapView: MKMapView!
    let mapManager=CLLocationManager()
    var prevMarker:MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.isHidden=true
        mapView.mapType = .hybrid
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
            let lat=mapManager.location?.coordinate.latitude
            let long=mapManager.location?.coordinate.longitude
            let location=CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let span=MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region=MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch=touches.first {
            let position=touch.location(in: mapView)
            let cord=mapView.convert(position, toCoordinateFrom: mapView)
            let marker=MKPointAnnotation()
            marker.coordinate=cord
            if prevMarker != nil{
                mapView.removeAnnotation(prevMarker)
                mapView.addAnnotation(marker)
                prevMarker=marker
                popUp.isHidden=false
            } else{
                prevMarker=marker
                mapView.addAnnotation(marker)
                popUp.isHidden=false
            }
        }
    }
    @IBAction func onExit(_ sender: Any) {
        popUp.isHidden=true
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
