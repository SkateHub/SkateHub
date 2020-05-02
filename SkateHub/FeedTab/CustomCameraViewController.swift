//
//  CustomCameraViewController.swift
//  SkateHub
//
//
//  Copyright © 2020 Jose Patino/Aldo Almeida/Paola Camacho. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var takePicBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var captureSession:AVCaptureSession!
    var stillImageOutput:AVCapturePhotoOutput!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    var sendPhoto:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVCaptureSession.Preset.medium

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession=AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let backCamera=AVCaptureDevice.default(for: AVMediaType.video) else {
            let alertController=UIAlertController(title: "Camera Error", message: "Back camera access denied", preferredStyle: UIAlertController.Style.alert)
            let action=UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true,completion: nil)
            return
        }
        do {
            let input =  try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput=AVCapturePhotoOutput()
            if (captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput)) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setUpLivePreview()
            }
        } catch let error {
            print("Error in starting back camera: \(error.localizedDescription)")
        }
        
    }
    
    func setUpLivePreview(){
        videoPreviewLayer=AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame=self.previewView.bounds
        }
        
        
        
    }
    
    @IBAction func onCapture(_ sender: Any) {
        let settings=AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData=photo.fileDataRepresentation() else {
            return
        }
        sendPhoto=UIImage(data: imageData)
        captureImageView.image=sendPhoto
        backBtn.isHidden=false
        let sys=UIImage(systemName: "checkmark.circle")
        takePicBtn.setBackgroundImage(sys, for: .selected)
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        setUpLivePreview()
        backBtn.isHidden=true
        let sys=UIImage(systemName: "stop.circle")
        takePicBtn.setBackgroundImage(sys, for: .normal)
    }
    
    @IBAction func onExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func grabPhoto(_ sender: Any) {
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
        sendPhoto=image
        self.dismiss(animated: true) {
            self.performSegue(withIdentifier: "sendIt", sender: nil)
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier=="sendIt"{
            let vc=segue.destination as! CameraViewController
            vc.retrievePhoto=sendPhoto
        }
    }
    

}
