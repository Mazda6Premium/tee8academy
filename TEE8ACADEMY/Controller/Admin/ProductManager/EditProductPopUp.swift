//
//  EditProductPopUp.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/17/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

protocol EditProductPopUpDelegate {
    func updateProduct()
}

class EditProductPopUp: BaseViewController {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    var product : Product?
    var timer : Timer?
    var delegate : EditProductPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpView()
    }
    
    func setUpView() {
        
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        txtName.isUserInteractionEnabled = false
        
        txtName.text = product!.name
        txtPrice.text = formatMoney(product!.price)
        
        roundCorner(views: [viewPopUp , txtName , txtPrice , btnDelete , btnEdit ], radius: 8)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.addGestureRecognizer(tapGes)
        
    }
    
    @objc func tapOnView() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func tapOnDelete(_ sender: Any) {
        databaseReference.child("Products").child(product!.id).removeValue()
        startTimer()
        showLoadingSuccess(1)
    }
    
    @IBAction func tapOnEdit(_ sender: Any) {
        self.view.endEditing(true)
        showLoading()
        
        if txtName.text == "" {
            showToast(message: "Bạn chưa điền đầy đủ thông tin.")
            hideLoading()
            return
        }
        
        
        guard let name = txtName.text else { return }
        guard let price = Double(txtPrice.text!.digits) else { return }
        let time = Date().millisecondsSince1970
        
        let value = ["name": name, "price" : price, "time" : time] as [String : Any]
        databaseReference.child("Products").child(product!.id).updateChildValues(value)
        
        startTimer()
        showLoadingSuccess(1)
        
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        
        delegate?.updateProduct()
        
        self.dismiss(animated: true, completion: nil)
        
        timer?.invalidate()
        timer = nil
    }
}
