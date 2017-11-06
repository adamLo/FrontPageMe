//
//  ComposeViewController.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 12/07/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import UIKit
import Photos

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleTouchArea: UIView!

    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var faceImageCenterX: NSLayoutConstraint!
    @IBOutlet weak var faceImageCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var photoHintLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    
    var originalPhoto: UIImage!

    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupTitle()
        addFace()
        
        photoHintLabel.isHidden = false
        restartButton.isHidden = false
        finishedButton.isHidden = false
        
        photoHintLabel.text = NSLocalizedString("You can drag, pinch and rotate the photo to adjust!", comment: "Hint label on composition screen")
        
        setupButtons()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Interaction
    
    private func setupTitle() {
        
        titleLabel.font = UIFont.defaultFont(style: .bold, size: 50.0)
        titleLabel.textColor = UIColor.white
        titleLabel.text = NSLocalizedString("Touch here to add your title!", comment: "Title label default text")
        titleLabel.isHidden = false
        
        titleTextField.placeholder = NSLocalizedString("Add your comment!", comment: "Title edit placeholder")
        titleTextField.isHidden = true
        titleTextField.font = UIFont.defaultFont(style: .regular, size: 20)
        
        titleTouchArea.isUserInteractionEnabled = true
    }
    
    private func setupButtons() {
        
        let buttonColor = UIColor.decosCyan
        for button in [restartButton, finishedButton] {
        
            button!.backgroundColor = buttonColor
            button!.setTitleColor(UIColor.white, for: .normal)
            button!.titleLabel!.font = UIFont.defaultFont(style: .bold, size: 35)
        }
        
        restartButton.setTitle(NSLocalizedString("START OVER", comment: "Start over button title"), for: .normal)
        finishedButton.setTitle(NSLocalizedString("FINISHED", comment: "Finished button title"), for: .normal)
    }
    
    private func toggleComponents(hidden: Bool) {
     
        titleTextField.resignFirstResponder()
        titleTextField.isHidden = true
        titleTouchArea.isUserInteractionEnabled = !hidden
        
        titleLabel.isHidden = false
        
        photoHintLabel.isHidden = hidden
        restartButton.isHidden = hidden
        finishedButton.isHidden = hidden
    }
    
    // MARK: - Photo management
    
    private func addFace() {
        
        let faceImage = originalPhoto.fixOrientation()//.masked(with: UIImage(named: "photo-mask")!)
        faceImageView.image = faceImage
        
//        var topConstant: CGFloat = 80
//        var leftConstant: CGFloat = 120
        
        if originalPhoto.size.width == 480.0 && originalPhoto.size.height == 640.0 {
            
//            topConstant = 520
//            leftConstant = 330
            
            faceImageView.transform = faceImageView.transform.scaledBy(x: 1.6, y: 1.6)
        }
        
//        faceImageTop.constant = topConstant
//        faceImageLead.constant = leftConstant
        
        view.layoutIfNeeded()
    }
    
    func save(image: UIImage, completionBlock: ((_ success: Bool, _ error: Error?) -> ())?) {
        
        var changeRequest: PHAssetChangeRequest!
        
        PHPhotoLibrary.shared().performChanges({
            
            changeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            changeRequest.creationDate = Date()
            
        }) { (success, error) in
            
            completionBlock?(success, error)
        }
    }
    
    // MARK: - Actions

    @IBAction func photoPanned(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        faceImageCenterY.constant += translation.y
        faceImageCenterX.constant += translation.x
        view.layoutIfNeeded()
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func photoPinched(_ sender: UIPinchGestureRecognizer) {
        
        faceImageView.transform = faceImageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    @IBAction func photoRotated(_ sender: UIRotationGestureRecognizer) {
        
        faceImageView.transform = faceImageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @IBAction func titleTapped(_ sender: Any) {

        titleLabel.isHidden = true
        titleTextField.isHidden = false
        titleTouchArea.isUserInteractionEnabled = false
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func titleDidEndOnExit(_ sender: Any) {
        
        titleTextField.resignFirstResponder()
        titleLabel.isHidden = false
        titleTextField.isHidden = true
        titleTouchArea.isUserInteractionEnabled = true
    }
    
    @IBAction func titleChanged(_ sender: UITextField) {
        
        titleLabel.text = sender.text != nil && sender.text!.characters.count > 0 ? sender.text : NSLocalizedString("Touch here to add your title!", comment: "Title label default text")
    }
    
    @IBAction func restartButtonTouched(_ sender: Any) {

        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func finishedButtonTouched(_ sender: Any) {

        toggleComponents(hidden: true)
        
        let rendered = view.getSnapshotImage()
        
        save(image: rendered) { (success, error) in
            
            DispatchQueue.main.async {
                
                self.toggleComponents(hidden: false)
                
                if success {
                    
                    UIAlertController.showOK(from: self, message: NSLocalizedString("Photo saved! Thank you!", comment: "Success message title when saved photo"), dismissedBlock: {
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
                else {
                    
                    UIAlertController.showError(from: self, message: error?.localizedDescription ?? "Unknown error Saving photo", dismissedBlock: nil)
                }
            }
        }
    }
    
    
}
