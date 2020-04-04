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
    }
    
    @IBAction func tapOnContinue(_ sender: Any) {
        view.endEditing(true)
        checkLogic()
        if user != nil {
            let vc = BuyCourseVC(nibName: "BuyCourseVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func checkLogic() {
        if txtEmail.text == "" && txtUsername.text == "" && txtPassword.text == "" && txtConfirmPassword.text == "" && txtAddress.text == "" && txtPhone.text == "" && txtRealName.text == "" {
            Toast(text: "Bạn cần điền đầy đủ thông tin").show()
        } else {
            if txtPassword.text!.count < 6 {
                Toast(text: "Mật khẩu của bạn cần tối thiểu 6 ký tự").show()
                return
            }
            
            if txtPassword.text! != txtConfirmPassword.text! {
                Toast(text: "Xác nhận mật khẩu không trùng khớp").show()
                return
            }
            
            if txtPhone.text!.count != 10 || !txtPhone.text!.hasPrefix("0") {
                Toast(text: "Số điện thoại không đúng định dạng").show()
                return
            }
            
            user = User(email: txtEmail.text!, username: txtUsername.text!, password: txtPassword.text!, confirmPassword: txtConfirmPassword.text!, address: txtAddress.text!, phone: txtPhone.text!, realName: txtRealName.text!, course: [Course]())
        }
    }
}
