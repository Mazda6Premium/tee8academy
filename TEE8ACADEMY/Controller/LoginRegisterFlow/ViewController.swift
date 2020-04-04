//
//  ViewController.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var imgFrame: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
//    @IBOutlet weak var imgLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    
    var imgLogo = UIImageView()
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationLogo()
    }
    
    func animationLogo() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 3, animations: {
            self.imgLogo.frame = self.imgFrame.frame
            self.view.layoutIfNeeded()
        }) { (_) in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
                self.changeAlpha(views: [self.txtEmail, self.txtPassword, self.lblLogin, self.btnForget, self.btnRegister], alpha: 1)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setupView() {
        roundCorner(views: [txtEmail, txtPassword], radius: 8)
        changeAlpha(views: [txtEmail, txtPassword, lblLogin, btnForget, btnRegister], alpha: 0)
        
        imgLogo.image = UIImage(named: "logo")
        imgLogo.frame = CGRect(x: 30, y: screenHeight, width: imgFrame.frame.width, height: imgFrame.frame.height)
        view.addSubview(imgLogo)
    }
    
    func changeAlpha(views : [UIView], alpha : CGFloat) {
        views.forEach { (view) in
            view.alpha = alpha
        }
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

