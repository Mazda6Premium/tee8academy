//
//  ChangePasswordPopup.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/19/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class ChangePasswordPopup: BaseViewController {
    
    @IBOutlet weak var txtOldPw: UITextField!
    @IBOutlet weak var txtNewPw: UITextField!
    @IBOutlet weak var txtConfirmNewPw: UITextField!
    @IBOutlet weak var btnHuy: UIButton!
    @IBOutlet weak var btnDoi: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        roundCorner(views: [txtOldPw, txtNewPw, txtConfirmNewPw, btnDoi, btnHuy], radius: 8)
        
        txtOldPw.delegate = self
        txtNewPw.delegate = self
        txtConfirmNewPw.delegate = self
    }
    
    @IBAction func tapOnHuy(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnDoi(_ sender: Any) {
        showLoading()
        if txtOldPw.text == "" || txtNewPw.text == "" || txtConfirmNewPw.text == "" {
            showToast(message: "Bạn cần điển đầy đủ thông tin.")
            hideLoading()
        } else {
            if let user = SessionData.shared.userData {
                if txtOldPw.text == user.password {
                    self.logicChangePassword(user: user)
                } else {
                    showToast(message: "Mật khẩu cũ không chính xác.")
                    txtOldPw.textColor = .red
                    hideLoading()
                }
            }
        }
    }
    
    func logicChangePassword(user: User) {
        if user.password == txtNewPw.text {
            showToast(message: "Mật khẩu mới không được giống mật khẩu cũ.")
            txtNewPw.textColor = .red
            hideLoading()
        } else {
            
            if txtNewPw.text!.count < 6 {
                txtNewPw.textColor = .red
                showToast(message: "Mật khẩu của bạn cần tối thiểu 6 ký tự.")
                hideLoading()
                return
            }
            
            if txtNewPw.text! != txtConfirmNewPw.text! {
                txtConfirmNewPw.textColor = .red
                showToast(message: "Xác nhận mật khẩu không trùng khớp.")
                hideLoading()
                return
            }
            
            let value = ["password": txtNewPw.text!]
            databaseReference.child("Users").child(user.userId).updateChildValues(value)
            self.showLoadingSuccess(1)
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(dismissView), userInfo: nil, repeats: false)
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

extension ChangePasswordPopup: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtOldPw:
            txtOldPw.textColor = .black
            return true
        case txtNewPw:
            txtNewPw.textColor = .black
            return true
        case txtConfirmNewPw:
            txtConfirmNewPw.textColor = .black
            return true
        default:
            return true
        }
    }
}
