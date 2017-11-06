//
//  StartViewController.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 05/11/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        presentScreenSaver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.decosCyan
        
        setupTitleLabel()
        setupMessageLabel()
        setupStartButton()
    }
    
    private func setupTitleLabel() {
        
        titleLabel.text = NSLocalizedString("start_title", comment: "Start screen title")
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.defaultFont(style: .semiBold, size: 60.0)
    }
    
    private func setupMessageLabel() {

        messageLabel.text = NSLocalizedString("start_message", comment: "Start screen message")
        messageLabel.textColor = UIColor.white
        messageLabel.font = UIFont.defaultFont(style: .light, size: 40.0)
    }
    
    private func setupStartButton() {
        
        startButton.setTitle("START", for: .normal)
        startButton.setTitleColor(UIColor.decosCyan, for: .normal)
        startButton.backgroundColor = UIColor.white
        startButton.titleLabel?.font = UIFont.defaultFont(style: .bold, size: 45.0)
    }
    
    @IBAction func startButtonTouched(_ sender: Any) {
        
        performSegue(withIdentifier: "photo", sender: self)
    }
    
    private func presentScreenSaver() {
        
        let controller = ScreenSaverViewController.controller()
        present(controller, animated: true) {
            //
        }
    }

}
