//
//  RegisterVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import Toast_Swift

class RegisterVC: BaseViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtRealName: UITextField!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnContactSupport: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        roundCorner(views: [txtEmail, txtUsername, txtPassword, txtConfirmPassword, txtAddress, txtPhone, txtRealName, btnContinue, btnContactSupport, btnBack], radius: 8)
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtPhone.delegate = self
        
        fakeData()
    }
    
    func fakeData() {
        txtEmail.text = "trung@gmail.com"
        txtUsername.text = "abc"
        txtPassword.text = "123456"
        txtConfirmPassword.text = "123456"
        txtAddress.text = "abc"
        txtPhone.text = "0942556886"
        txtRealName.text = "abc"
    }
    
    @IBAction func tapOnContinue(_ sender: Any) {
        view.endEditing(true)
        showLoading()
        checkLogic()
        if user != nil {
            print(user?.asDictionary())
            // CHECK EMAIL EXISTS OR NOT
            // IF NOT -> CONTINUE
            databaseReference.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: user!.email).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    self.showToast(message: "Email đã tồn tại, vui lòng nhập email khác.")
                    self.txtEmail.textColor = .red
                    self.hideLoading()
                } else {
                    self.checkPhone()
                }
            }
        }
    }
    
    func checkPhone() {
        databaseReference.child("Users").queryOrdered(byChild: "phone").queryEqual(toValue: self.user!.phone).observeSingleEvent(of: .value) { (snapshot1) in
            if snapshot1.exists() {
                self.showToast(message: "Số điện thoại đã tồn tại, vui lòng nhập số điện thoại khác.")
                self.txtPhone.textColor = .red
                self.hideLoading()
            } else {
                let vc = BuyCourseVC(nibName: "BuyCourseVC", bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.user = self.user
                self.hideLoading()
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func checkLogic() {
        if txtEmail.text == "" || txtUsername.text == "" || txtPassword.text == "" || txtConfirmPassword.text == "" || txtAddress.text == "" || txtPhone.text == "" || txtRealName.text == "" {
            showToast(message: "Bạn cần điền đầy đủ thông tin.")
        } else {
            if !txtEmail.text!.isValidEmail {
                txtEmail.textColor = .red
                showToast(message: "Email không đúng định dạng.")
                hideLoading()
                return
            }
            
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
            
            if !txtPhone.text!.hasPrefix("0") || txtPhone.text!.hasPrefix("00") {
                txtPhone.textColor = .red
                showToast(message: "Số điện thoại không đúng định dạng.")
                hideLoading()
                return
            }
            
            guard let phoneId = UIDevice.current.identifierForVendor?.uuidString else {return}
            let phoneModel = UIDevice.modelName

            user = User(email: txtEmail.text!, username: txtUsername.text!, password: txtPassword.text!, confirmPassword: txtConfirmPassword.text!, address: txtAddress.text!, phone: txtPhone.text!, realName: txtRealName.text!, course: [Course](), paymentMethod: "", imagePayment: "", phoneId: phoneId, phoneModel: phoneModel, time: 0, totalPayment: 0, postId: "", userId: "")
        }
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtEmail.textColor = .black
            return true
        case txtPassword:
            txtPassword.textColor = .black
            return true
        case txtConfirmPassword:
            txtConfirmPassword.textColor = .black
            return true
        case txtPhone:
            txtPhone.textColor = .black
            return true
        default:
            return true
        }
    }
}
