//
//  MapViewController.swift
//  SkateHub
//
//  Created by Aldo Almeida on 4/8/20.
//  Copyright © 2020 Jose Patino. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController {

    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var mapView: MKMapView!
    let mapManager=CLLocationManager()
    var prevMarker:MKPointAnnotation!
    var coordinates:CLLocationCoordinate2D!
    var spots=[PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.isHidden=true
        mapView.mapType = .hybrid
        serviceCheck()
        updateSpots()
        // Do any additional setup after loading the view.
    }

    func updateSpots(){
        let query=PFQuery(className: "Spots")
        query.findObjectsInBackground(block: {(spot,error) in
            if(spot != nil){
                self.spots=spot!
                self.createMarkers()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSpots()
    }
    
    func createMarkers(){
        for location in spots{
            let marker=MKPointAnnotation()
            let lat=location["coordinates"] as! PFGeoPoint
            let convertedLat=CLLocationCoordinate2D(latitude: lat.latitude, longitude: lat.longitude)
            marker.coordinate=convertedLat
            mapView.addAnnotation(marker)
        }
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
            let location = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
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
            coordinates=cord
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
    
    @IBAction func onSpot(_ sender: Any) {
        let convert=PFGeoPoint(latitude: coordinates.latitude , longitude: coordinates.longitude )
        let spot=PFObject(className: "Spots")
        spot["coordinates"]=convert
        spot.saveInBackground(block: { (success,error) in
            if success{
                print("spot saved")
            } else{
                print("Error with spot!")
            }
        })
        
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
