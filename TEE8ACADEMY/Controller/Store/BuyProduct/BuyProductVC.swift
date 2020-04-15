//
//  BuyProductVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/14/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import SDWebImage

protocol BuyProductDelegate {
    func addToCart(cart: [Cart])
}

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
    
    var product : Product?
    var number = 1
    var totalPrice = 0.0
    var arrayCart = [Cart]()
    var delegate: BuyProductDelegate?
    
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
        
        roundCorner(views: [viewProduct , imgProduct , tvDescription], radius: 8)
        roundCorner(views: [btnAdd], radius: 8)
        
        addBorder(views: [imgProduct], width: 1, color: #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
        
        if let data = product {
            if let url = URL(string: data.imageUrl) {
                imgProduct.sd_setImage(with: url, completed: nil)
            } else {
                imgProduct.image = UIImage(named: "placeholder")
            }
            lblName.text = data.name
            lblPrice.text = "Giá tiền: \(formatMoney(data.price)) VND"
            lblNumberBuy.text = "\(number)"
            tvDescription.text = data.description
            totalPrice = data.price * Double(number)
            lblTotal.text = "Tổng: \(formatMoney(self.totalPrice)) VND"
        }

        
    }
    
    @IBAction func tapOnDecrease(_ sender: Any) {
        number -= 1
        DispatchQueue.main.async {
            if let data = self.product {
                self.lblNumberBuy.text = "\(self.number)"
                self.totalPrice = data.price * Double(self.number)
                self.lblTotal.text = "Tổng: \(formatMoney(self.totalPrice)) VND"
            }
        }
        if number == 1 {
            btnDecrease.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func tapOnIncrease(_ sender: Any) {
        number += 1
        DispatchQueue.main.async {
            if let data = self.product {
                self.lblNumberBuy.text = "\(self.number)"
                self.totalPrice = data.price * Double(self.number)
                self.lblTotal.text = "Tổng: \(formatMoney(self.totalPrice)) VND"
            }
        }
        btnDecrease.isUserInteractionEnabled = true
    }
    
    @IBAction func tapOnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnAddToCart(_ sender: Any) {
        if let data = self.product {
            let cart = Cart(id: data.id, name: data.name, description: data.description, price: data.price, totalPrice: self.totalPrice, quantity: number, imageUrl: data.imageUrl)
            
            if arrayCart.count > 0 {
                for value in arrayCart {
                    if value.name == cart.name {
                        if let indexObject = self.arrayCart.firstIndex(where: {$0.name == cart.name}) {
                            self.arrayCart[indexObject].quantity += cart.quantity
                            break
                        }
                    } else {
                        self.arrayCart.append(cart)
                        break
                    }
                }
            } else {
                self.arrayCart.append(cart)
            }
        }
        delegate?.addToCart(cart: self.arrayCart)
        dismiss(animated: true, completion: nil)
    }
}
