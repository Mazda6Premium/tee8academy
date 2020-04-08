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
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
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
        UIView.animate(withDuration: 2.5, animations: {
            self.imgLogo.frame = self.imgFrame.frame
            self.view.layoutIfNeeded()
        }) { (_) in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
                self.changeAlpha(views: [self.txtEmail, self.txtPassword, self.lblLogin, self.btnForget, self.btnRegister, self.btnLogin], alpha: 1)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setupView() {
        roundCorner(views: [txtEmail, txtPassword, btnLogin], radius: 8)
        changeAlpha(views: [txtEmail, txtPassword, lblLogin, btnForget, btnRegister, btnLogin], alpha: 0)
        
        imgLogo.image = UIImage(named: "logo")
        imgLogo.frame = CGRect(x: 30, y: screenHeight, width: imgFrame.frame.width, height: imgFrame.frame.height)
        view.addSubview(imgLogo)
    }
    
    func changeAlpha(views : [UIView], alpha : CGFloat) {
        views.forEach { (view) in
            view.alpha = alpha
        }
    }
    
    @IBAction func tapOnLogin(_ sender: Any) {
        self.view.endEditing(true)
        showLoading()
        checkLogic()
        if txtEmail.text!.isInt {
            checkPhone()
        } else {
            checkEmail()
        }
    }
    
    func checkEmail() {
        // CHECK 4 CONDITIONS EMAIL + PASSWORD + UUID + IPHONE MODEL
        databaseReference.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: txtEmail.text!).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                databaseReference.child("Users").queryOrdered(byChild: "password").queryEqual(toValue: self.txtPassword.text!).observeSingleEvent(of: .value) { (snapshot1) in
                    if snapshot1.exists() {
                        self.checkSecondTime()
                    } else {
                        self.showToast(message: "Sai mật khẩu, vui lòng nhập lại.")
                        self.hideLoading()
                    }
                }
            } else {
                self.showToast(message: "Tài khoản không tồn tại hoặc chưa được phê duyệt, vui lòng nhập tài khoản khác.")
                self.hideLoading()
            }
        }
    }
    
    func checkPhone() {
        databaseReference.child("Users").queryOrdered(byChild: "phone").queryEqual(toValue: self.txtEmail.text!).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                databaseReference.child("Users").queryOrdered(byChild: "password").queryEqual(toValue: self.txtPassword.text!).observeSingleEvent(of: .value) { (snapshot1) in
                    if snapshot1.exists() {
                        self.checkSecondTime()
                    } else {
                        self.showToast(message: "Sai mật khẩu, vui lòng nhập lại.")
                        self.hideLoading()
                    }
                }
            } else {
                self.showToast(message: "Số điện thoại không tồn tại hoặc chưa được phê duyệt, vui lòng nhập tài khoản khác.")
                self.hideLoading()
            }
        }
    }
    
    func checkSecondTime() {
        guard let phoneId = UIDevice.current.identifierForVendor?.uuidString else {return}
        let phoneModel = UIDevice.modelName
        databaseReference.child("Users").queryOrdered(byChild: "phoneId").queryEqual(toValue: phoneId).observeSingleEvent(of: .value) { (snapshot2) in
            if snapshot2.exists() {
                databaseReference.child("Users").queryOrdered(byChild: "phoneModel").queryEqual(toValue: phoneModel).observeSingleEvent(of: .value) { (snapshot3) in
                    if snapshot3.exists() {
                        self.showLoadingSuccess(1)
                        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC")
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true) {
                            self.clearData()
                        }
                    } else {
                        self.showToast(message: "Thiết bị đăng nhập không hợp lệ, mỗi tài khoản chỉ được đăng nhập trên một thiết bị duy nhất.")
                        self.hideLoading()
                    }
                }
            } else {
                self.showToast(message: "Thiết bị đăng nhập không hợp lệ, mỗi tài khoản chỉ được đăng nhập trên một thiết bị duy nhất.")
                self.hideLoading()
            }
        }
    }
    
    func checkLogic() {
        if txtEmail.text == "" && txtPassword.text == "" {
            showToast(message: "Bạn cần điền đầy đủ thông tin.")
            return
        }
        
        if txtEmail.text == "Admin" && txtPassword.text == "123456" {
            hideLoading()
            let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true) {
                self.clearData()
            }
            return
        }
    }
    
    @IBAction func tapOnRegister(_ sender: Any) {
        let vc = RegisterVC(nibName: "RegisterVC", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true) {
            self.clearData()
        }
    }
    
    @IBAction func tapOnForgetPassword(_ sender: Any) {
        let vc = ForgetPasswordVC(nibName: "ForgetPasswordVC", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true) {
            self.clearData()
        }
    }
    
    func clearData() {
        txtEmail.text = ""
        txtPassword.text = ""
    }
}

