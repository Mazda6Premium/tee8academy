//
//  BuyProductVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/14/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import SDWebImage

class BuyProductVC: BaseViewController {
    
    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblNumberBuy: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDecrease: UIButton!
    
    var product : Product!
    
//    var imageName = ""
//    var name = ""
//    var price = 0.0
//    var productDescrip = ""
    var number = 1
    var totalPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setUpView()
    }
    
    func setUpView() {
        
        if number == 1 {
            btnDecrease.isUserInteractionEnabled = false
        } else {
            btnDecrease.isUserInteractionEnabled = true
        }
        
        roundCorner(views: [viewProduct , imgProduct , tvDescription ], radius: 10)
        roundCorner(views: [btnAdd], radius: 20)
        
        addBorder(views: [imgProduct], width: 1, color: UIColor.black.cgColor)
        
        if let url = URL(string: product.imageUrl) {
            imgProduct.sd_setImage(with: url, completed: nil)
        } else {
            imgProduct.image = UIImage(named: "placeholder")
        }
        lblName.text = product.name
        lblPrice.text = "Giá tiền : \(formatMoney(self.product.price)) VND"
        lblNumberBuy.text = "\(number)"
        tvDescription.text = product.description
        totalPrice = product.price * Double(number)
        lblTotal.text = "Tổng : \(formatMoney(self.totalPrice)) VND"
        
    }
    
    @IBAction func tapOnDecrease(_ sender: Any) {
        number -= 1
        
        DispatchQueue.main.async {
            self.lblNumberBuy.text = "\(self.number)"
            self.totalPrice = self.product.price * Double(self.number)
            self.lblTotal.text = "Tổng : \(formatMoney(self.totalPrice)) VND"
        }
        
        if number == 1 {
            btnDecrease.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func tapOnIncrease(_ sender: Any) {
        number += 1
        
        DispatchQueue.main.async {
            self.lblNumberBuy.text = "\(self.number)"
            self.totalPrice = self.product.price * Double(self.number)
            self.lblTotal.text = "Tổng : \(formatMoney(self.totalPrice)) VND"

        }
        
        btnDecrease.isUserInteractionEnabled = true
    }
    @IBAction func tapOnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
