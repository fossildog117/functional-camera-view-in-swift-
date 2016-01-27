//
//  cameraViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Nathan Liu on 26/01/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import AVFoundation

class camera: UIViewController, UIPickerViewDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
        
    func configureDevice() throws {
        if let device = captureDevice {
            try device.lockForConfiguration()
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
    }
    
    func focusTo(value: Float) {
        if let device = captureDevice {
            
            do {
                try device.lockForConfiguration()
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in })
                device.unlockForConfiguration()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func beginSession() throws {
        
        do {
            try configureDevice()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let err: NSError? = nil
        
        try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        
        if err != nil {
            print(err?.localizedDescription)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    
    }
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anyTouch = (touches.first)! as UITouch
        let touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anyTouch = touches.first! as UITouch
        let touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()

        for device in devices {
            
            if (device.hasMediaType(AVMediaTypeVideo)) {
                
                if device.position == AVCaptureDevicePosition.Back {
                    
                    captureDevice = device as? AVCaptureDevice
                    
                }
                
            }
            
        }
        
        if captureDevice != nil {
            do {
                try beginSession()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
