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
    
    @IBOutlet weak var viewHoTen: UIView!
    @IBOutlet weak var viewSoDT: UIView!
    @IBOutlet weak var viewDiaChi: UIView!
    
    @IBOutlet weak var txtHoTen: UITextField!
    @IBOutlet weak var txtSoDT: UITextField!
    @IBOutlet weak var txtDiaChi: UITextField!
    
    var arrayCart = [Cart]()
    var delegate: PopupCheckOutDelegate?
    var quantity = 0
    var total = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [btnAddToCart, btnPlaceOrder, viewCheckout, viewHoTen, viewSoDT, viewDiaChi], radius: 8)
        
        lblLoaiSP.text = "\(arrayCart.count)"


        arrayCart.forEach { (cart) in
            quantity += cart.quantity
            lblSoLuong.text = "\(quantity)"
            total += cart.price * Double(cart.quantity)
            lblTongGiaTien.text = formatMoney(total)
        }
        
        if let user = SessionData.shared.userData {
            txtHoTen.text = user.realName
            txtSoDT.text = user.phone
            txtDiaChi.text = user.address
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
        if txtSoDT.text == "" || txtDiaChi.text == "" {
            showToast(message: "Bạn cần điển đẩy đủ thông tin")
            hideLoading()
            return
        }
        
        if let user = SessionData.shared.userData {
            let date = Date()
            let time = date.timeIntervalSince1970 * 1000
            
            let order = Order(userId: user.userId, username: user.username, phone: txtSoDT.text!, address: txtDiaChi.text!, cart: arrayCart, realname: user.realName, time: time, quantity: self.quantity, totalPayment: self.total)
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
