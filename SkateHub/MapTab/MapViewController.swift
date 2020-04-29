//
//  MapViewController.swift
//  SkateHub
//
//  Copyright © 2020 Jose Patino/Aldo Almeida/Paola Camacho All rights reserved.
//

import UIKit
import MapKit
import Parse
import CoreLocation

class MapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var spotView: UIView!
    @IBOutlet weak var spotLabel: UITextView!
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitBtn: UIButton!
    var mapManager=CLLocationManager()
    var prevMarker:MKPointAnnotation!
    var coordinates:CLLocationCoordinate2D!
    var spots=[PFObject]()
    var menuOn=true
    var height:CGFloat!
    var editEnabled=false
    var check=false
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet var tapGes: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .hybrid
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        menuBtn.layer.cornerRadius=6
        self.mapManager.requestAlwaysAuthorization()
        self.mapManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            mapManager.delegate=self
            mapManager.desiredAccuracy=kCLLocationAccuracyBest
            mapView.setUserTrackingMode(.follow, animated: true)
            mapManager.startUpdatingLocation()
        }
        updateSpots()
        addBtn.layer.cornerRadius=6
        submitBtn.layer.cornerRadius=6
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.showsUserLocation=true
        if !check{
            let location=locations.last! as CLLocation
            let center=CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span=MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            let region=MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            check=true
        }
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if let frame:NSValue=notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboard=frame.cgRectValue
            height=keyboard.height
            if height<100{
                spotView.transform=CGAffineTransform.identity
            } else{
            spotView.transform=CGAffineTransform(translationX: 0, y: -height)
            }
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
        check=false
    }
    
    func createMarkers(){
        for location in spots{
            let marker=MKPointAnnotation()
            let lat=location["coordinates"] as! PFGeoPoint
            let convertedLat=CLLocationCoordinate2D(latitude: lat.latitude, longitude: lat.longitude)
            let name=location["name"] as! String
            marker.coordinate=convertedLat
            marker.title=name
            mapView.addAnnotation(marker)
        }
    }
    
    
    @IBAction func onImagePicker(_ sender: Any) {
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
                let span=MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
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
            }
        }
        if editEnabled == false && prevMarker != nil{
            mapView.removeAnnotation(prevMarker)
        }
    }
    
    
    @IBAction func onSpot(_ sender: Any) {
        self.submitBtn.isEnabled=false
        let convert=PFGeoPoint(latitude: coordinates.latitude , longitude: coordinates.longitude )
        let spot=PFObject(className: "Spots")
        spot["coordinates"]=convert
        spot["name"]=spotLabel.text
        let imageData=spotImage.image?.pngData()
        let imageFile=PFFileObject(name: "spotImage.png", data: imageData!)
        spot["spotImage"]=imageFile
        if spotLabel.text.count>25 {
            let alrtContrl=UIAlertController(title: "Spot name too long", message: "Please shorten to less than 25 characters.", preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .default, handler: nil)
            alrtContrl.addAction(action)
            self.present(alrtContrl,animated: true,completion: nil)
        } else{
            spot.saveInBackground(block: { (success,error) in
                if success{
                    print("spot saved")
                    self.submitBtn.isEnabled=true
                } else{
                    print("Error with spot!")
                }
            })
            spotView.isHidden=true
            spotImage.image=nil
            spotLabel.text="Enter spot name here..."
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
