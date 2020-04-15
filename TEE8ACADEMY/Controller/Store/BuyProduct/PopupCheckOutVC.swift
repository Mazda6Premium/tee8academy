//
//  PopupCheckOutVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

protocol PopupCheckOutDelegate {
    func clearCart()
}

class PopupCheckOutVC: BaseViewController {
    
    @IBOutlet weak var viewCheckout: UIView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var lblLoaiSP: UILabel!
    @IBOutlet weak var lblSoLuong: UILabel!
    @IBOutlet weak var lblTongGiaTien: UILabel!
    
    var arrayCart = [Cart]()
    var delegate: PopupCheckOutDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [btnAddToCart, btnPlaceOrder, viewCheckout], radius: 8)
        
        lblLoaiSP.text = "\(arrayCart.count)"
        var quantity = 0
        var total = 0.0

        arrayCart.forEach { (cart) in
            quantity += cart.quantity
            lblSoLuong.text = "\(quantity)"
            total += cart.price
            lblTongGiaTien.text = formatMoney(total)
        }
    }
    
    @IBAction func tapOnClosePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapOnAddProduct(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapOnPlaceOrder(_ sender: Any) {
        showLoading()
        if let user = SessionData.shared.userData {
            let order = Order(userId: user.userId, cart: arrayCart)
            let key = databaseReference.childByAutoId().key!
            databaseReference.child("Orders").child(key).setValue(order.asDictionary())
            showLoadingSuccess(1)
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(dismissView), userInfo: nil, repeats: false)
        }
    }
    
    @objc func dismissView() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        SessionData.shared.cart = nil
        delegate?.clearCart()
    }
}
