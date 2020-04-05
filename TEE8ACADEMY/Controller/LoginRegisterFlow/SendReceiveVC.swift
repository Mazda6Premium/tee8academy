//
//  SendReceiveVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SendReceiptVC: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPaypal: UIButton!
    @IBOutlet weak var btnVCB: UIButton!
    @IBOutlet weak var imgReceipt: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnContactSupport: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var lblUpload: UILabel!
    
    var user: User?
    var imagePicker = UIImagePickerController()
    var paymentMethod = ""
    var chooseImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        roundCorner(views: [btnSubmit, btnContactSupport, btnPaypal, btnVCB, imgReceipt], radius: 8)
        
        addBorder(views: [imgReceipt], width: 1, color: #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1))
        
        if let user = user {
            var totalBill = 0.0
            user.course.forEach { (course) in
                totalBill += course.price
            }
            let priceTotal = formatMoney(totalBill)
            lblTitle.text = "Your total bills is \(priceTotal) VND, please make payment to active your account."
        }
        
        imgReceipt.isHidden = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapOnUpload(_:)))
        imgReceipt.isUserInteractionEnabled = true
        imgReceipt.addGestureRecognizer(tapGes)
    }
    
    @IBAction func tapOnPaypal(_ sender: Any) {
        addBorder(views: [btnPaypal], width: 1, color: #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1))
        addBorder(views: [btnVCB], width: 0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        paymentMethod = "Paypal"
        
        let vc = PopupPaymentVC(nibName: "PopupPaymentVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.payment = .paypal
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapOnVCB(_ sender: Any) {
        addBorder(views: [btnVCB], width: 1, color: #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1))
        addBorder(views: [btnPaypal], width: 0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        paymentMethod = "Vietcombank"
        
        let vc = PopupPaymentVC(nibName: "PopupPaymentVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.payment = .vcb
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapOnUpload(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func tapOnSubmit(_ sender: Any) {
        
        if paymentMethod == "" {
            showToast(message: "Bạn chưa chọn phương thức thanh toán.")
            return
        }
        
        guard let image = chooseImage else {
            showToast(message: "Bạn chưa tải lên hoá đơn thanh toán.")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
            return
        }
        
        showProgressLoading()
    }
    

}

extension SendReceiptVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgReceipt.image = chosenImage
            self.chooseImage = chosenImage
            self.imgReceipt.isHidden = false
            self.btnUpload.isHidden = true
            self.lblUpload.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
}
