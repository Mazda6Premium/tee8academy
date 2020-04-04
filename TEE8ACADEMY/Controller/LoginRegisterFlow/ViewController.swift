//
//  ViewController.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    func setupView() {
        roundCorner(views: [txtEmail, txtPassword], radius: 8)
    }
    
    @IBAction func tapOnRegister(_ sender: Any) {
        let vc = RegisterVC(nibName: "RegisterVC", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapOnForgetPassword(_ sender: Any) {
    }
}

