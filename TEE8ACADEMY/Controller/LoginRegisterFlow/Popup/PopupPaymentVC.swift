//
//  PopupPaymentVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/5/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

enum Payment {
    case paypal
    case vcb
}

class PopupPaymentVC: BaseViewController {
    
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var lblTenTK: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblChiNhanh: UILabel!
    @IBOutlet weak var viewImage: UIView!
    
    var payment: Payment = Payment.paypal
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        addBorder(views: [viewImage], width: 1, color: #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1))
        roundCorner(views: [viewPayment, viewImage], radius: 8)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGes)
        
        switch payment {
        case .paypal:
            imgPayment.image = UIImage(named: "paypal")
            lblTenTK.isHidden = true
            lblChiNhanh.isHidden = true
            lblPayment.text = "Email: mythvietnamese@gmail.com"
        case .vcb:
            imgPayment.image = UIImage(named: "vcb")
            lblTenTK.isHidden = false
            lblChiNhanh.isHidden = false
            lblPayment.text = "Số TK: 0181002910814"
        }
    }
    
    @IBAction func tapOnCopy(_ sender: Any) {
        switch payment {
        case .paypal:
            UIPasteboard.general.string = "mythvietnamese@gmail.com"
            showToast(message: "Đã copy email Paypal")
        case .vcb:
            UIPasteboard.general.string = "0181002910814"
            showToast(message: "Đã copy số tài khoản Vietcombank.")
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
