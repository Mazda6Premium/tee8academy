//
//  SendReceiveVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class SendReceiptVC: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPaypal: UIButton!
    @IBOutlet weak var btnVCB: UIButton!
    @IBOutlet weak var imgReceipt: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnContactSupport: UIButton!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        roundCorner(views: [btnSubmit, btnContactSupport, btnPaypal, btnVCB], radius: 8)
        
        if let user = user {
            var totalBill = 0.0
            user.course.forEach { (course) in
                totalBill += course.price
            }
            let priceTotal = formatMoney(totalBill)
            lblTitle.text = "Your total bills is \(priceTotal) VND, please make payment to active your account."
        }
        
        imgReceipt.isHidden = true
    }
    
    @IBAction func tapOnPaypal(_ sender: Any) {
        addBorder(views: [btnPaypal], width: 1, color: #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1))
        addBorder(views: [btnVCB], width: 0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    @IBAction func tapOnVCB(_ sender: Any) {
        addBorder(views: [btnVCB], width: 1, color: #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1))
        addBorder(views: [btnPaypal], width: 0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
}
