//
//  EditPopUpVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/14/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

protocol EditPopUpDelegate {
    func refreshData()
}

class EditPopUpVC: BaseViewController {

    @IBOutlet weak var viewDim: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var course : Course?
    var timer : Timer?
    var delegate : EditPopUpDelegate?
    var allCoursePrice = 0.0
    var sale : Double = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpView()
    }
    
    func setUpView() {
        
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        txtName.isUserInteractionEnabled = false
        
        txtName.text = course!.name
        txtPrice.text = formatMoney(course!.price)
        tvDescription.text = course!.description
        
        roundCorner(views: [viewDim , txtName , txtPrice , tvDescription , btnCancel , btnConfirm ], radius: 8)
        
    }
    
    @IBAction func tapOnConfirm(_ sender: Any) {
        self.view.endEditing(true)
        showLoading()
        
        if txtName.text == "" || tvDescription.text == "" {
            showToast(message: "Bạn chưa điền đầy đủ thông tin.")
            hideLoading()
            return
        }
        
        
        guard let name = txtName.text else { return }
        guard let description = tvDescription.text else { return }
        guard let price = Double(txtPrice.text!.digits) else { return }
        let time = Date().millisecondsSince1970
        
        let value = ["description": description, "price" : price, "time" : time] as [String : Any]
        databaseReference.child("Courses").child(name).updateChildValues(value)
        
        allCoursePrice += price
        let priceAfterSale = allCoursePrice * ( 1 - sale / 100)
        databaseReference.child("Courses").child("ALL COURSE").updateChildValues(["price" : priceAfterSale])
        startTimer()
        showLoadingSuccess(1)
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        
        delegate?.refreshData()
        
        self.dismiss(animated: true, completion: nil)
        
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
