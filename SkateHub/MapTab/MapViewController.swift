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

class MapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var spotView: UIView!
    @IBOutlet weak var spotLabel: UITextView!
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitBtn: UIButton!
    let mapManager=CLLocationManager()
    var prevMarker:MKPointAnnotation!
    var coordinates:CLLocationCoordinate2D!
    var spots=[PFObject]()
    var menuOn=true
    var height:CGFloat!
    var editEnabled=false
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet var tapGes: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .hybrid
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        menuBtn.layer.cornerRadius=6
        serviceCheck()
        updateSpots()
        submitBtn.layer.cornerRadius=6
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if let frame:NSValue=notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboard=frame.cgRectValue
            height=keyboard.height
            print(height)
        }
    }
    
    @IBAction func onMenu(_ sender: Any) {
        menuOn = !menuOn
        if menuOn{
            self.tabBarController?.tabBar.isHidden=false
        } else{
            self.tabBarController?.tabBar.isHidden=true
        }
    }
    @IBAction func onEdit(_ sender: Any) {
        editEnabled = !editEnabled
        if editEnabled{
            self.tabBarController?.tabBar.isHidden=true
            menuBtn.isHidden=true
            editBtn.tintColor=UIColor.green
        } else{
            self.tabBarController?.tabBar.isHidden=false
            menuBtn.isHidden=false
            editBtn.isSelected=false
            editBtn.tintColor=UIColor.red
            spotView.isHidden=true
        }
    }
    @IBAction func onBack(_ sender: Any) {
        tapGes.isEnabled=true
        spotView.isHidden=true
    }
    @IBAction func onNameLabel(_ sender: Any){
        print("working")
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
    
    @IBAction func onImagePicker(_ sender: Any) {
        print("Clicked")
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable( .camera)){
            picker.sourceType = .camera
        } else{
            picker.sourceType = .photoLibrary
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        spotImage.image=image
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editEnabled && tapGes.isEnabled{
            if spotView.isHidden{
                spotView.isHidden=false
            }
            if let touch=touches.first {
                let position=touch.location(in: mapView)
                let cord=mapView.convert(position, toCoordinateFrom: mapView)
                coordinates=cord
                let marker=MKPointAnnotation()
                marker.coordinate=cord
                tapGes.isEnabled=false
                let span=MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region=MKCoordinateRegion(center: coordinates, span: span)
                mapView.setRegion(region, animated: true)
                if prevMarker != nil{
                    mapView.removeAnnotation(prevMarker)
                    mapView.addAnnotation(marker)
                    prevMarker=marker
                } else{
                    prevMarker=marker
                    mapView.addAnnotation(marker)
                }
               // self.performSegue(withIdentifier: "spotMenu", sender: nil)
            }
        }
        if editEnabled == false && prevMarker != nil{
            mapView.removeAnnotation(prevMarker)
        }
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
