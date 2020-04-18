//
//  ViewController.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: BaseViewController {
    
    @IBOutlet weak var imgFrame: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var imgLogo = UIImageView()
    var user: User?
    
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
        
        imgLogo.image = UIImage(named: "image")
        imgLogo.frame = CGRect(x: 30, y: screenHeight, width: imgFrame.frame.width, height: imgFrame.frame.height)
        view.addSubview(imgLogo)
        
        txtEmail.delegate = self
        txtPassword.delegate = self
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
        // CHECK 4 CONDITIONS PASSWORD + UUID + IPHONE MODEL
        if let user = user {
            if user.email == "admin" {
                self.loginSuccess()
                return
            }
            guard let phoneId = UIDevice.current.identifierForVendor?.uuidString else {return}
            let phoneModel = UIDevice.modelName
            guard let password = txtPassword.text else {return}
            if password == user.password { // CHECK PASSWORD
                if phoneId == user.phoneId && phoneModel == user.phoneModel { // CHECK ID AND MODEL
                    if !user.isBlock {
                        self.loginSuccess()
                    } else {
                        self.showToast(message: "Tài khoản của bạn đã bị khoá do vi phạm quy định của ứng dụng, vui lòng liên hệ quản trị viên để biết thêm thông tin chi tiết.", duration: 5)
                        self.hideLoading()
                    }
                } else {
                    self.showToast(message: "Thiết bị đăng nhập không hợp lệ, mỗi tài khoản chỉ được đăng nhập trên một thiết bị duy nhất, vui lòng liên hệ quản trị viên để biết thêm thông tin chi tiết.", duration: 5)
                    self.hideLoading()
                }
            } else {
                self.showToast(message: "Sai mật khẩu, vui lòng nhập lại.")
                self.hideLoading()
            }
        } else {
            showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
            hideLoading()
        }
    }
    
    func checkLogic() {
        if txtEmail.text == "" && txtPassword.text == "" {
            showToast(message: "Bạn cần điền đầy đủ thông tin.")
            hideLoading()
            return
        }
    }
    
    func loginSuccess() {
        self.showLoadingSuccess(1)
        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        // CACHE IN SESSION DATA USING SINGLETON
        SessionData.shared.userData = user
        
        self.present(vc, animated: true) {
            self.clearData()
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

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmail {
            guard let text = txtEmail.text else {return}
            if text.isInt {
                assignData(key: "phone")
            } else {
                assignData(key: "email")
            }
        }
    }
    
    func assignData(key: String) {
        databaseReference.child("Users").queryOrdered(byChild: "\(key)").queryEqual(toValue: txtEmail.text!).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                self.hideLoading()
                for child in snapshot.children {
                    guard let data = child as? DataSnapshot else {return}
                    if let dict = data.value as? [String: Any] {
                        self.user = User(dict: dict)
                    }
                }
            }
        }
    }
}
