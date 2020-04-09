//
//  PushProductVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/9/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class PushProductVC: BaseViewController {
    
    @IBOutlet weak var viewPush: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtPriceSale: CurrencyTextField!
    @IBOutlet weak var btnPost: UIButton!
    
    var imageProduct : UIImage?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    func setUpView() {
        roundCorner(views: [txtName, txtType, tvDescription, txtPrice, imgProduct, btnPost], radius: 8)
        addShadow(views: [viewPush])
        
        txtType.delegate = self
        
        if txtPrice.text == "0" {
            txtPrice.text = ""
        }
        
        if txtPriceSale.text == "0" {
            txtPriceSale.text = ""
        }
        
        imgProduct.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgProduct.addGestureRecognizer(tapGesture)
    }
    
    @objc func chooseImage() {
        let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Thư viện Ảnh", comment: ""), style: .default, handler: { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let takePhotoAction = UIAlertAction(title: NSLocalizedString("Chụp ảnh", comment: ""), style: .default, handler: { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Huỷ", comment: ""), style: .cancel, handler: { _ in
        })
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true) { () -> Void in
        }
    }
    @IBAction func tapOnPost(_ sender: Any) {
        self.view.endEditing(true)
        showLoading()
        
        if txtName.text == "" || tvDescription.text == "" || txtPrice.text == "" || txtType.text == "" {
            showToast(message: "Bạn chưa điền đầy đủ thông tin.")
            hideLoading()
            return
        }
        
        if imageProduct == nil {
            showToast(message: "Bạn chưa chọn ảnh")
            hideLoading()
            return
        }
        
        if txtPriceSale.text == "" {
            txtPriceSale.text = "0"
        } else {
            let sale = Double(txtPriceSale.text!.digits)!
            if sale > 100.0 {
                showToast(message: "Số bạn nhập không hợp lệ")
                hideLoading()
                return
            }
        }
        
        guard let name = txtName.text else { return }
        guard let description = tvDescription.text else { return }
        guard let price = Double(txtPrice.text!.digits) else { return }
        guard let sale = Double(txtPriceSale.text!.digits) else { return }
        guard let type = txtType.text else { return }
        let time = Date().millisecondsSince1970
        let id = databaseReference.childByAutoId().key!
        
        guard let image = imageProduct, let data = image.jpegData(compressionQuality: 0.1) else {return}
        let imageName = Date().millisecondsSince1970
        let imageStorage = storageReference.child("ImageProduct").child("\(imageName)")
        imageStorage.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                self.showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
                return
            }
            imageStorage.downloadURL(completion: { (url, error) in
                guard let imageUrl = url else {
                    self.showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
                    return
                }
                let value = ["type": type , "id" : id , "name": name, "description": description, "price" : price, "sale" : sale , "imageUrl" : "\(String(describing: imageUrl))" , "time" : time] as [String : Any]
                databaseReference.child("Products").child(id).setValue(value)
                self.startTimer()
                self.showLoadingSuccess(1)
            })
        }
        startTimer()
        showLoadingSuccess(1)
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        txtName.text = ""
        tvDescription.text = ""
        txtPrice.text = ""
        txtPriceSale.text = ""
        txtType.text = ""
        
        imageProduct = nil
        imgProduct.image = UIImage(named: "placeholder")
        
        timer?.invalidate()
        timer = nil
    }
    
    
    @IBAction func tapOnDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PushProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageProduct = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgProduct.image = imageProduct
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PushProductVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        ActionSheetStringPicker.show(withTitle: "Chọn loại", rows: ["P.M.U PLUS", "TIMES"], initialSelection: 0, doneBlock: { (picker, index, value) in
            if let type = value as? String {
                self.txtType.text = type
            }
        }, cancel: { (picker) in
            return
        }, origin: txtType)
        return false
    }
}
