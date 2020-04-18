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
    @IBOutlet weak var viewG: UIView!
    @IBOutlet weak var viewH: UIView!
    @IBOutlet weak var viewI: UIView!
    
    @IBOutlet weak var lblA: UILabel!
    @IBOutlet weak var lblB: UILabel!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblD: UILabel!
    @IBOutlet weak var lblE: UILabel!
    @IBOutlet weak var lblF: UILabel!
    @IBOutlet weak var lblG: UILabel!
    @IBOutlet weak var lblH: UILabel!
    @IBOutlet weak var lblI: UILabel!
    @IBOutlet weak var topConstr: NSLayoutConstraint!
    
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
            break
        case .user:
            lblA.text = "Mua khoá học"
            lblB.text = "Thông tin cá nhân"
            lblC.text = "Lịch sử giao dịch"
            lblD.text = "Góp ý"
            lblE.text = "Đổi mật khẩu"
            lblF.text = "Đăng xuất"
            
            viewG.isHidden = true
            viewH.isHidden = true
            viewI.isHidden = true
            topConstr.constant = 50
        default:
            break
        }
    }
    
    func setupView() {
        roundCorner(views: [viewA, viewB, viewC, viewD, viewE, viewF, viewG, viewH, viewI], radius: 10)
        addBorder(views: [viewA, viewB, viewC, viewD, viewE, viewF, viewG, viewH, viewI], width: 1, color: #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
        
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
        
        let tapGes7 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewG))
        viewG.addGestureRecognizer(tapGes7)
        
        let tapGes8 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewH))
        viewH.addGestureRecognizer(tapGes8)
        
        let tapGes9 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewI))
        viewI.addGestureRecognizer(tapGes9)
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
            vc.pushVC = .course
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
        case .admin: // ĐĂNG VIDEO
            let vc = PushCourseVC(nibName: "PushCourseVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.pushVC = .video
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
        case .admin: // ĐĂNG SẢN PHẨM
            let vc = PushProductVC(nibName: "PushProductVC", bundle: nil)
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
        case .admin: // QUẢN LÝ KHOÁ HỌC
            let vc = EditCourseVC(nibName: "EditCourseVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case .user: // ĐỔI MẬT KHẨU
            showToast(message: "Chức năng đang được xây dựng")
            return
        default:
            break
        }
    }
    
    @objc func tapOnViewF() {
        UIView.animate(withDuration: 0.3) {
            self.viewF.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewF.alpha = 1
            }
        }
        
        switch account {
        case .admin: // QUẢN LÝ VIDEO
            let vc = EditVideoVC(nibName: "EditVideoVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case .user: // ĐĂNG XUẤT
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            // DELETE CACHE IN SESSION DATA USING SINGLETON
            SessionData.shared.userData = nil
            self.present(vc, animated: true, completion: nil)
            return
        default:
            break
        }
    }
    
    @objc func tapOnViewG() {
        UIView.animate(withDuration: 0.3) {
            self.viewG.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewG.alpha = 1
            }
        }
        
        let vc = ProductManagerVC(nibName: "ProductManagerVC", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func tapOnViewH() {
        UIView.animate(withDuration: 0.3) {
            self.viewH.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewH.alpha = 1
            }
        }
        // QUẢN LÝ THÀNH VIÊN
        let vc = UserManagerVC(nibName: "UserManagerVC", bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func tapOnViewI() {
        UIView.animate(withDuration: 0.3) {
            self.viewI.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewI.alpha = 1
            }
        }
        // ĐĂNG XUẤT
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        // DELETE CACHE IN SESSION DATA USING SINGLETON
        SessionData.shared.userData = nil
        self.present(vc, animated: true, completion: nil)
    }
}

