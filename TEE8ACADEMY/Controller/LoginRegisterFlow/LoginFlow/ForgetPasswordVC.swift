//
//  ForgetPasswordVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/8/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ForgetPasswordVC: BaseViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnContactSupport: UIButton!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        roundCorner(views: [txtEmail, txtPhone, btnContinue, btnContactSupport, btnBack], radius: 8)
        self.txtPhone.isHidden = true
        
        txtEmail.delegate = self
        txtPhone.delegate = self
    }
    
    @IBAction func tapOnContinue(_ sender: Any) {
        view.endEditing(true)
        showLoading()
        if txtEmail.text == "" && txtPhone.text == "" {
            showToast(message: "Bạn cần điền đầy đủ thông tin.")
            hideLoading()
            return
        } else {
            checkPhone()
        }
    }
    
    func checkLogic() {
        databaseReference.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: txtEmail.text!).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                self.txtPhone.isHidden = false
                self.hideLoading()
                for child in snapshot.children {
                    guard let data = child as? DataSnapshot else {return}
                    if let dict = data.value as? [String: Any] {
                        self.user = User(dict: dict)
                    }
                }
            } else {
                self.showToast(message: "Email không tồn tại, vui lòng nhập email khác.")
                self.txtEmail.textColor = .red
                self.hideLoading()
            }
        }
    }
    
    func checkPhone() {
        if txtPhone.text == "" {
            showToast(message: "Bạn cần điền đầy đủ thông tin.")
            hideLoading()
            return
        } else {
            if !txtPhone.text!.hasPrefix("0") || txtPhone.text!.hasPrefix("00") {
                txtPhone.textColor = .red
                showToast(message: "Số điện thoại không đúng định dạng.")
                hideLoading()
                return
            }
            
            if txtPhone.text == user?.phone {
                self.showLoadingSuccess(1)
                let vc = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.user = self.user
                self.present(vc, animated: true, completion: nil)
            } else {
                self.showToast(message: "Số điện thoại không chính xác, vui lòng nhập lại.")
                self.txtPhone.textColor = .red
                self.hideLoading()
            }
        }
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ForgetPasswordVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtEmail.textColor = .black
            return true
        case txtPhone:
            txtPhone.textColor = .black
            return true
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmail {
            showLoading()
            if !txtEmail.text!.isValidEmail {
                txtEmail.textColor = .red
                showToast(message: "Email không đúng định dạng.")
                hideLoading()
            } else {
                checkLogic()
            }
        }
    }
}
