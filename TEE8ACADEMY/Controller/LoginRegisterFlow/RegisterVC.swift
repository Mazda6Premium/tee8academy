//
//  RegisterVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import Toaster

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
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        roundCorner(views: [txtEmail, txtUsername, txtPassword, txtConfirmPassword, txtAddress, txtPhone, txtRealName, btnContinue, btnContactSupport], radius: 8)
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtPhone.delegate = self
    }
    
    @IBAction func tapOnContinue(_ sender: Any) {
        view.endEditing(true)
        checkLogic()
        if user != nil {
            print(user?.asDictionary())
            let vc = SendReceiveVC(nibName: "SendReceiveVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func checkLogic() {
        if txtEmail.text == "" && txtUsername.text == "" && txtPassword.text == "" && txtConfirmPassword.text == "" && txtAddress.text == "" && txtPhone.text == "" && txtRealName.text == "" {
            Toast(text: "Bạn cần điền đầy đủ thông tin").show()
        } else {
            if !txtEmail.text!.isValidEmail {
                txtEmail.textColor = .red
                Toast(text: "Định dạng email không hợp lệ").show()
                return
            }
            
            if txtPassword.text!.count < 6 {
                txtPassword.textColor = .red
                Toast(text: "Mật khẩu của bạn cần tối thiểu 6 ký tự").show()
                return
            }
            
            if txtPassword.text! != txtConfirmPassword.text! {
                txtConfirmPassword.textColor = .red
                Toast(text: "Xác nhận mật khẩu không trùng khớp").show()
                return
            }
            
            if txtPhone.text!.count != 10 || !txtPhone.text!.hasPrefix("0") || txtPhone.text!.hasPrefix("00") {
                txtPhone.textColor = .red
                Toast(text: "Số điện thoại không đúng định dạng").show()
                return
            }
            
            guard let phoneId = UIDevice.current.identifierForVendor?.uuidString else {return}
            let phoneModel = UIDevice.modelName

            user = User(email: txtEmail.text!, username: txtUsername.text!, password: txtPassword.text!, confirmPassword: txtConfirmPassword.text!, address: txtAddress.text!, phone: txtPhone.text!, realName: txtRealName.text!, course: [Course](), phoneId: phoneId, phoneModel: phoneModel)
        }
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
