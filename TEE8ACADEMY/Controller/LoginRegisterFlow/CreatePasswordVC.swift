//
//  CreatePasswordVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/12/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class CreatePasswordVC: BaseViewController {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        roundCorner(views: [txtPassword, txtConfirmPassword, btnRegister, btnContact, btnBack], radius: 8)
        
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnRegister(_ sender: Any) {
        checkLogic()
        
        if let userData = user {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyy"
            let time = date.timeIntervalSince1970 * 1000
            userData.time = time
            userData.password = txtPassword.text!
            
            databaseReference.child("Users").child(userData.userId).setValue(userData.asDictionary())
            self.showLoadingSuccess(2)
            showToast(message: "Chúc mừng bạn đã tạo tài khoản thành công.")
            txtPassword.text = ""
            txtConfirmPassword.text = ""
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissView), userInfo: nil, repeats: false)
        }
    }
    
    @objc func dismissView() {
        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        // CACHE IN SESSION DATA USING SINGLETON
        SessionData.shared.userData = user
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
}
