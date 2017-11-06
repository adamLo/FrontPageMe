//
//  CameraViewController.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 12/07/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera: AVCaptureDevice?
    var mainCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCameraOverlay()
        
        UIApplication.shared.isStatusBarHidden = true
        navigationController?.isNavigationBarHidden = true
        hintLabel.text = NSLocalizedString("Make a photo of yourself!", comment: "Hint on camera screen")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        stopTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if previewLayer != nil {
            
            updatePreviewLayerFrame()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "compose" {
            
            let target = segue.destination as! ComposeViewController
            target.originalPhoto = sender as? UIImage
        }
    }
    
    @IBAction func shootButtonTouched(_ sender: Any) {
        
        takePhoto()
    }

    // MARK: - Camera
    
    private func setupCameraOverlay() {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        shootButton.isEnabled = false
        
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if device.hasMediaType(AVMediaType.video) {
                    // Finally check the position and confirm we've got the back camera
                    if device.position == .back {
                        mainCamera = device
                    }
                    else if device.position == .front {
                        frontCamera = device
                    }
                }
            }
        }
        
        if frontCamera != nil {
            
            currentDevice = frontCamera
        
            shootButton.isEnabled = true
        
            beginAVSession()
        }
        else {
            
            UIAlertController.showError(from: self, message: NSLocalizedString("Your device doesn't seem to have front camera:(", comment: "No front camera error message"), dismissedBlock: nil)
        }
    }
    
    func beginAVSession() {
        
        if previewLayer != nil {
            
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
        
        do {
            let added = captureSession.inputs.contains(where: { (device) -> Bool in
                return device as? AVCaptureDeviceInput === currentDevice
            })
            if !added {
                try captureSession.addInput(AVCaptureDeviceInput(device: currentDevice!))
            }
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        catch {
            print("error: \(error.localizedDescription)")
            
            UIAlertController.showError(from: self, message: NSLocalizedString("There was an error initializing your camera", comment: "Camera initializing error message"), dismissedBlock: nil)
            
            return
        }
        
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if layer != nil {
            
            previewLayer = layer
            
            previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill;
            
            self.view.layer.insertSublayer(previewLayer!, at: 0)
            previewLayer!.needsDisplayOnBoundsChange = true
            updatePreviewLayerFrame()
            
            captureSession.startRunning()
        }
        else {
            
            print("no preview layer")
            
            UIAlertController.showError(from: self, message: NSLocalizedString("There was an error initializing your camera", comment: "Camera initializing error message"), dismissedBlock: nil)
        }
    }
    
    private func updatePreviewLayerFrame() {
        
        if previewLayer != nil {
            
            let frame = CGRect(x:0, y:0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            previewLayer!.frame = frame
            previewLayer!.bounds = frame
        }
    }

    func takePhoto() {
        
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            
            stopTimer()
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, error) in
                
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer!) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.performSegue(withIdentifier: "compose", sender: cameraImage)
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                        
                            UIAlertController.showError(from: self, message: "Cannot decode image:(", dismissedBlock: nil)
                            
                            self.startTimer()
                        })
                    }
                }
                else {
                    DispatchQueue.main.async(execute: {
                    
                        UIAlertController.showError(from: self, message: "Error capturing image", dismissedBlock: nil)
                        
                        self.startTimer()
                    })
                }
            })
        }
    }
    @IBAction func backButtonTouched(_ sender: Any) {
        
        stopTimer()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Timer
    
    private var backTimer: Timer?
    private let backTimeout: TimeInterval = 5 * 60
    
    private func startTimer() {
        
        stopTimer()
        
        backTimer = Timer.scheduledTimer(timeInterval: backTimeout, target: self, selector: #selector(backTimerFired(timer:)), userInfo: nil, repeats: false)
    }
    
    private func stopTimer() {
        
        if backTimer != nil {
            
            backTimer!.invalidate()
            
            backTimer = nil
        }
    }
    
    @objc func backTimerFired(timer: Timer) {
        
        stopTimer()
        navigationController?.popToRootViewController(animated: true)
    }
}
