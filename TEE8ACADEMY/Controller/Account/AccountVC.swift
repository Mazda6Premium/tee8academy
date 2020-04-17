//
//  AccountVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/13/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

enum AccountType {
    case admin
    case user
}

class AccountVC: BaseViewController {
    
    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var viewB: UIView!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var viewD: UIView!
    @IBOutlet weak var viewE: UIView!
    @IBOutlet weak var viewF: UIView!
    
    @IBOutlet weak var lblA: UILabel!
    @IBOutlet weak var lblB: UILabel!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblD: UILabel!
    @IBOutlet weak var lblE: UILabel!
    
    var account: AccountType?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        userType()
    }
    
    func userType() {
        if let user = SessionData.shared.userData {
            if user.email == "admin" {
                account = .admin
            } else {
                account = .user
            }
        }
        
        switch account {
        case .admin:
            lblA.text = "Đơn hàng"
            lblB.text = "Đăng khoá học"
            lblC.text = "Đăng sản phẩm"
            lblD.text = "Quản lý khoá học"
            lblE.text = "Quản lý sản phẩm"
        case .user:
            lblA.text = "Mua khoá học"
            lblB.text = "Thông tin cá nhân"
            lblC.text = "Lịch sử giao dịch"
            lblD.text = "Góp ý"
            lblE.text = "Đổi mật khẩu"
        default:
            break
        }
    }
    
    func setupView() {
        roundCorner(views: [viewA, viewB, viewC, viewD, viewE, viewF], radius: 10)
        addBorder(views: [viewA, viewB, viewC, viewD, viewE, viewF], width: 1, color: #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
        
        let tapGes1 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewA))
        viewA.addGestureRecognizer(tapGes1)
        
        let tapGes2 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewB))
        viewB.addGestureRecognizer(tapGes2)
        
        let tapGes3 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewC))
        viewC.addGestureRecognizer(tapGes3)
        
        let tapGes4 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewD))
        viewD.addGestureRecognizer(tapGes4)
        
        let tapGes5 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewE))
        viewE.addGestureRecognizer(tapGes5)
        
        let tapGes6 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewF))
        viewF.addGestureRecognizer(tapGes6)
    }
    
    @objc func tapOnViewA() {
        UIView.animate(withDuration: 0.3) {
            self.viewA.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewA.alpha = 1
            }
        }
        
        switch account {
        case .admin: // ĐƠN HÀNG
            let vc = RegisterAccountVC(nibName: "RegisterAccountVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case .user: // MUA KHOÁ HỌC
            let vc = BuyCourseVC(nibName: "BuyCourseVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @objc func tapOnViewB() {
        UIView.animate(withDuration: 0.3) {
            self.viewB.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewB.alpha = 1
            }
        }
        
        switch account {
        case .admin: // ĐĂNG KHOÁ HỌC
            let vc = PushCourseVC(nibName: "PushCourseVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case .user: // THÔNG TIN CÁ NHÂN
            showToast(message: "Chức năng đang được xây dựng")
            return
        default:
            break
        }
    }
    
    @objc func tapOnViewC() {
        UIView.animate(withDuration: 0.3) {
            self.viewC.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewC.alpha = 1
            }
        }
        
        switch account {
        case .admin: // ĐĂNG SẢN PHẨM
            let vc = PushProductVC(nibName: "PushProductVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case .user: // LỊCH SỬ GIAO DỊCH
            showToast(message: "Chức năng đang được xây dựng")
            return
        default:
            break
        }
    }
    
    @objc func tapOnViewD() { 
        UIView.animate(withDuration: 0.3) {
            self.viewD.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewD.alpha = 1
            }
        }
        
        switch account {
        case .admin: // QUẢN LÝ KHOÁ HỌC
            let vc = EditCourseVC(nibName: "EditCourseVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case .user: // GÓP Ý
            showToast(message: "Chức năng đang được xây dựng")
            return
        default:
            break
        }
        
    }
    
    @objc func tapOnViewE() {
        UIView.animate(withDuration: 0.3) {
            self.viewE.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewE.alpha = 1
            }
        }
        
        switch account {
        case .admin: // QUẢN LÝ SẢN PHẨM
            let vc = PushProductVC(nibName: "PushProductVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case .user: // ĐỎI MẬT KHẨU
            showToast(message: "Chức năng đang được xây dựng")
            return
        default:
            break
        }
    }
    
    @objc func tapOnViewF() { // ĐĂNG XUẤT
        UIView.animate(withDuration: 0.3) {
            self.viewD.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewD.alpha = 1
            }
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        // DELETE CACHE IN SESSION DATA USING SINGLETON
        SessionData.shared.userData = nil
        self.present(vc, animated: true, completion: nil)
    }
}

