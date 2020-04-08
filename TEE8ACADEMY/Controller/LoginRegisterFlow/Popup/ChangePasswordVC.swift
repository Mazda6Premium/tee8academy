//
//  ChangePasswordVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/8/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {
    
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewPopup, txtPassword, txtConfirmPassword, btnContinue], radius: 8)
        
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGes)
    }
    
    @IBAction func tapOnContinue(_ sender: Any) {
        view.endEditing(true)
        showLoading()
        checkLogic()
        // CHANGE PASSWORD IN SERVER
        if let user = user {
            let value = ["password" : "\(txtPassword.text!)"]
            databaseReference.child("Users").child(user.userId).updateChildValues(value)
            self.showLoadingSuccess(2)
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(showLogin), userInfo: nil, repeats: false)
        }
    }
    
    @objc func showLogin() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    func checkLogic() {
        if txtPassword.text == "" || txtConfirmPassword.text == "" {
            showToast(message: "Bạn cần điền đầy đủ thông tin.")
            return
        } else {
            if txtPassword.text!.count < 6 {
                txtPassword.textColor = .red
                showToast(message: "Mật khẩu của bạn cần tối thiểu 6 ký tự.")
                hideLoading()
                return
            }
            
            if txtPassword.text! != txtConfirmPassword.text! {
                txtConfirmPassword.textColor = .red
                showToast(message: "Xác nhận mật khẩu không trùng khớp.")
                hideLoading()
                return
            }
        }
    }
    
    @objc func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtPassword:
            txtPassword.textColor = .black
            return true
        case txtConfirmPassword:
            txtConfirmPassword.textColor = .black
            return true
        default:
            return true
        }
    }
}
