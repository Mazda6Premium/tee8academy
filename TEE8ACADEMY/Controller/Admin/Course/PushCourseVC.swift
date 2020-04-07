//
//  PushCourseVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/7/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class PushCourseVC: BaseViewController {
    
    @IBOutlet weak var viewPush: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgCourse: UIImageView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtLinkVid: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    
    var courseImage : UIImage?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    func setUpView() {
        roundCorner(views: [txtName, tvDescription, imgCourse, txtPrice, txtLinkVid, txtType, btnPost], radius: 8)
        
        viewPush.layer.cornerRadius = 10
        viewPush.layer.masksToBounds = true
        viewPush.layer.shadowOpacity = 0.5
        viewPush.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewPush.layer.shadowColor = UIColor.darkGray.cgColor
        viewPush.clipsToBounds = false
        viewPush.backgroundColor = .white
        
        txtLinkVid.isUserInteractionEnabled = false
        imgCourse.isUserInteractionEnabled = false
        
        txtType.delegate = self
        
        if txtPrice.text == "0" {
            txtPrice.text = ""
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgCourse.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func tapOnPost(_ sender: Any) {
        self.view.endEditing(true)
        showLoading()
        if txtType.text == "Video" && txtLinkVid.text == "" {
            showToast(message: "Bạn chưa điền đầy đủ thông tin.")
            hideLoading()
            return
        }
        
        if txtType.text == "Ảnh" && courseImage == nil {
            showToast(message: "Bạn chưa chọn ảnh")
            hideLoading()
            return
        }
        
        
        if txtName.text == "" || tvDescription.text == "" || txtPrice.text == "" || txtType.text == "" {
            showToast(message: "Bạn chưa điền đầy đủ thông tin.")
            hideLoading()
            return
        }
        
        
        guard let name = txtName.text else { return }
        guard let description = tvDescription.text else { return }
        guard let price = Double(txtPrice.text!.digits) else { return }
        let time = Date().millisecondsSince1970
        
        switch txtType.text {
        case "Video":
            guard let video = txtLinkVid.text else { return }
            let value = ["name": name, "description": description, "price" : price , "linkVideo" : video, "time" : time] as [String : Any]
            databaseReference.child("Courses").child(name).setValue(value)
            startTimer()
            showLoadingSuccess(1)
        case "Ảnh":
            guard let image = courseImage, let data = image.jpegData(compressionQuality: 0.1) else {return}
            let imageName = Date().millisecondsSince1970
            let imageStorage = storageReference.child("ImageCourse").child("\(imageName)")
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
                    let value = ["name": name, "description": description, "price" : price , "imageUrl" : "\(String(describing: imageUrl))" , "time" : time] as [String : Any]
                    databaseReference.child("Courses").child(name).setValue(value)
                    self.startTimer()
                    self.showLoadingSuccess(1)
                })
            }
        default:
            return
        }
        
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        txtName.text = ""
        txtLinkVid.text = ""
        txtType.text = ""
        txtPrice.text = ""
        tvDescription.text = ""
        courseImage = nil
        imgCourse.image = UIImage(named: "placeholder")
        
        txtLinkVid.isUserInteractionEnabled = false
        imgCourse.isUserInteractionEnabled = false
        
        timer?.invalidate()
        timer = nil
        
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
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PushCourseVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        ActionSheetStringPicker.show(withTitle: "Chọn loại", rows: ["Video", "Ảnh"], initialSelection: 0, doneBlock: { (picker, index, value) in
            if let type = value as? String {
                self.txtType.text = type
                
            }
            if self.txtType.text == "Video" {
                self.txtLinkVid.isUserInteractionEnabled = true
                self.imgCourse.isUserInteractionEnabled = false
                self.courseImage = nil
                self.imgCourse.image = UIImage(named: "placeholder")
                
            }
            
            if self.txtType.text == "Ảnh" {
                self.imgCourse.isUserInteractionEnabled = true
                self.txtLinkVid.isUserInteractionEnabled = false
                self.txtLinkVid.text = ""
            }
        }, cancel: { (picker) in
            return
        }, origin: txtType)
        
        return false
    }
    
}

extension PushCourseVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        courseImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgCourse.image = courseImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
