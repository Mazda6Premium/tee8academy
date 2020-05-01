//
//  VerifyAccountVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/12/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FirebaseAuth

enum CaseRegister {
    case otp
    case email
}

class VerifyAccountVC: BaseViewController {
    
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var btnSendAgain: UIButton!
    @IBOutlet weak var btnVerifyAccount: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    
    var user: User?
    var second = 60
    var timer = Timer()
    var verificationId = ""
    var caseRegis = CaseRegister.otp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func loginWithPhoneNumber(phone: String) {
        let rightFormatPhone = "+84\(phone)"
        print(rightFormatPhone)
        PhoneAuthProvider.provider().verifyPhoneNumber(rightFormatPhone, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                print("firebase registration \(String(describing: verificationID))")
                if let id = verificationID {
                    self.verificationId = id
                }
            } else {
                self.showToast(message: error!.localizedDescription)
            }
        }
    }
    
    func setupView() {
        roundCorner(views: [txtOTP, btnConfirm, btnContact, btnBack], radius: 8)
        
        if let user = user {
            loginWithPhoneNumber(phone: user.phone)
        }
        
        txtOTP.delegate = self
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnConfirm(_ sender: Any) {
        self.view.endEditing(true)
        // enter otp
        showLoading()
        
        switch caseRegis {
        case .otp:
            logWithPhone()
        case .email:
            logWithEmail()
        }
    }
    
    func logWithPhone() {
        guard let verificationCode = self.txtOTP.text else {
            self.view.makeToast("Bạn chưa nhập mã OTP.")
            hideLoading()
            return
        }
        
        // SHOW SETPASSWORD -> LOGIN
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (userRegis, error) in
            // TODO: handle sign in
            if error != nil {
                self.showToast(message: "Sai mã OTP.")
                self.hideLoading()
                
            } else {
                guard let id = userRegis?.user.uid else {
                    self.showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
                    return
                }
                
                self.showLoadingSuccess()
                self.user?.userId = id
                
                let vc = CreatePasswordVC(nibName: "CreatePasswordVC", bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.user = self.user
                self.present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
    func logWithEmail() {
        auth.currentUser?.reload(completion: { (error) in
            if error != nil {
                self.showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
                return
            } else {
                if let authUser = auth.currentUser {
                    if authUser.isEmailVerified {
                        self.user?.userId = authUser.uid
                        let vc = CreatePasswordVC(nibName: "CreatePasswordVC", bundle: nil)
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.user = self.user
                        self.showLoadingSuccess(2)
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        self.showToast(message: "Email chưa được xác thực, vui lòng thử lại.")
                        self.hideLoading()
                        return
                    }
                }
            }
        })
    }
    
    @IBAction func tapOnVerifyEmail(_ sender: Any) {
        caseRegis = .email
        self.view.endEditing(true)
        self.showToast(message: "Email xác thực đã được gửi.")
        if let user = user {
            auth.createUser(withEmail: user.email, password: "123456") { (authData, error) in
                if error != nil {
                    self.showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
                    return
                }
                
                if let authUser = auth.currentUser {
                    if !authUser.isEmailVerified {
                        authUser.sendEmailVerification(completion: { (error) in
                            // Notify the user that the mail has sent or couldn't because of an error.
                            if error != nil {
                                self.showToast(message: "Có lỗi xảy ra, email xác thực chưa được gửi.")
                                return
                            }
                        })
                    } else {
                        // Either the user is not available, or the user is already verified.
                        self.showToast(message: "Tài khoản của bạn đã được xác thực.")
                        return
                    }
                } else {
                    self.showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
                    return
                }
            }
        }

        
    }
    
    @IBAction func tapOnResend(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendOTPAgain), userInfo: nil, repeats: true)
    }
    
    @objc func sendOTPAgain() {
        second -= 1
        if second == 0 {
            if let user = user {
                loginWithPhoneNumber(phone: user.phone)
                btnSendAgain.setTitle("SEND AGAIN", for: .normal)
                timer.invalidate()
                second = 60
            }
        } else {
            btnSendAgain.setTitle("GET OTP AFTER \(second) SECOND", for: .normal)
        }
    }
}

extension VerifyAccountVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if caseRegis == .email {
            self.showToast(message: "Bạn đã chọn phương thức xác thực tài khoản bằng email. Vui lòng kiểm tra email để xác thực tài khoản.")
            return false
        } else {
            return true
        }
    }
}
