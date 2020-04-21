//
//  PushCourseVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/7/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import AVKit
import XCDYouTubeKit

enum PushVC {
    case course
    case video
}

class PushCourseVC: BaseViewController {
    
    @IBOutlet weak var viewPush: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var tvDescriptionCourse: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    
    @IBOutlet weak var viewPushVideo: UIView!
    @IBOutlet weak var txtNameVideo: UITextField!
    @IBOutlet weak var imgCourse: UIImageView!
    @IBOutlet weak var txtLinkVid: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtChooseCourse: UITextField!
    @IBOutlet weak var tvDescriptionVideo: UITextView!
    @IBOutlet weak var txtIndexVideo: UITextField!
    @IBOutlet weak var btnPostVideo: UIButton!
    
    var arrayCourse = [Course]()
    var arrayNameCourse = [String]()
    var courseImage : UIImage?
    var timer : Timer?
    var arrayVideo = [Video]()
    var allCoursePrice = 0.0
    var sale = 0.2
    
    var pushVC: PushVC = .course
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpView()
        getDataFromFirebase()
    }
    
    func setUpView() {
        switch pushVC {
        case .course:
            viewPush.isHidden = false
            viewPushVideo.isHidden = true
        case .video:
            viewPush.isHidden = true
            viewPushVideo.isHidden = false
        }
        
        roundCorner(views: [txtName, txtPrice, tvDescriptionCourse, btnPost, txtNameVideo, imgCourse, txtLinkVid, txtType, txtChooseCourse, tvDescriptionVideo, btnPostVideo], radius: 8)
        addShadow(views: [viewPush, viewPushVideo])
        
        txtLinkVid.isUserInteractionEnabled = false
        imgCourse.isUserInteractionEnabled = false
        
        txtType.delegate = self
        txtChooseCourse.delegate = self
        
        if txtPrice.text == "0" {
            txtPrice.text = ""
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgCourse.addGestureRecognizer(tapGesture)
    }
    
    func getDataFromFirebase() {
        showLoading()
        databaseReference.child("Courses").observe(.childAdded) { (snapshot) in
            databaseReference.child("Courses").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let course = Course(fromDict: dict)
                    
                    if course.name == "ALL COURSE" {
                        self.allCoursePrice = course.price
                    }
                    
                    self.arrayCourse.append(course)
                    self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                        return Int64(course1.price) > Int64(course2.price)
                    })
                    self.arrayNameCourse.append(course.name)
                    self.showLoadingSuccess(1)
                }
            }
        }
    }
    
    @IBAction func tapOnPostCourse(_ sender: Any) {
        self.view.endEditing(true)
        showLoading()
        
        if txtName.text == "" || tvDescriptionCourse.text == "" || txtPrice.text == "" {
            showToast(message: "Bạn chưa điền đầy đủ thông tin.")
            hideLoading()
            return
        }
        
        guard let name = txtName.text else { return }
        guard let description = tvDescriptionCourse.text else { return }
        guard let price = Double(txtPrice.text!.digits) else { return }
        let time = Date().millisecondsSince1970
        
        let value = ["name": name, "description": description, "price" : price, "time" : time] as [String : Any]
        databaseReference.child("Courses").child(name).setValue(value)
        
        let priceAfterSale = (self.allCoursePrice / (1 - self.sale) + price) * (1 - self.sale)
        databaseReference.child("Courses").child("ALL COURSE").updateChildValues(["price" : priceAfterSale])

        startTimer()
        showLoadingSuccess(1)
        
    }
    
    @IBAction func tapOnPostVideo(_ sender: Any) {
        self.view.endEditing(true)
        showLoading()
        
        if txtChooseCourse.text == "" {
            showToast(message: "Bạn chưa chọn khoá học")
            hideLoading()
            return
        }
        
        if txtNameVideo.text == "" || tvDescriptionVideo.text == "" || txtType.text == "" {
            showToast(message: "Bạn chưa điền đầy đủ thông tin.")
            hideLoading()
            return
        }
        
        if txtType.text == "Video" {
            if txtLinkVid.text == "" {
                showToast(message: "Bạn chưa điền link video.")
                hideLoading()
                return
            }
            
            if txtIndexVideo.text == "" {
                showToast(message: "Bạn chưa điền index video.")
                hideLoading()
                return
            }
        }
        
        if txtType.text == "Ảnh" {
            if courseImage == nil {
                showToast(message: "Bạn chưa chọn ảnh")
                hideLoading()
                return
            }
        }
        
        guard let nameVideoOrImage = txtNameVideo.text else { return }
        guard let nameCourseChoose = txtChooseCourse.text else { return }
        guard let description = tvDescriptionVideo.text else { return }
        guard let type = txtType.text else { return }
        guard let index = Int(txtIndexVideo.text!) else { return }
        let time = Date().millisecondsSince1970
        let id = databaseReference.childByAutoId().key!

        switch txtType.text {
        case "Video":
            guard let linkVideo = txtLinkVid.text else { return }
            print(nameCourseChoose)
            let video = Video(name: nameVideoOrImage, course: nameCourseChoose, description: description, id: id, linkVideo: linkVideo, time: time, type: type, imageUrl: "", index: index)
            
            self.arrayVideo.append(video)
            let course = Course(video: arrayVideo)
            databaseReference.child("Courses").child(nameCourseChoose).updateChildValues(course.asDictionaryVideo())
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
                    
                    let video = Video(name: nameVideoOrImage, course: nameCourseChoose, description: description, id: id, linkVideo: "", time: time, type: type, imageUrl: "\(imageUrl)", index: index)
                    self.arrayVideo.append(video)
                    let course = Course(video: self.arrayVideo)
                    databaseReference.child("Courses").child(nameCourseChoose).updateChildValues(course.asDictionaryVideo())
                    self.startTimer()
                    self.showLoadingSuccess(1)
                })
            }
        default:
            return
        }
    }
    
    func getDataVideo(nameCourseChoose: String) {
        databaseReference.child("Courses").child(nameCourseChoose).child("videos").observeSingleEvent(of: .value) { (snapshot) in
            if let video = snapshot.value as? [[String: Any]] {
                self.arrayVideo = video.map({Video(dict: $0)})
            }
        }
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        txtName.text = ""
        tvDescriptionCourse.text = ""
        txtPrice.text = ""

        txtNameVideo.text = ""
        txtChooseCourse.text = ""
        txtType.text = ""
        tvDescriptionVideo.text = ""
        txtLinkVid.text = ""
        txtIndexVideo.text = ""
        courseImage = nil
        imgCourse.image = UIImage(named: "placeholder")
        arrayVideo.removeAll()
        
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
        
        switch textField {
        case txtType:
            ActionSheetStringPicker(title: "Chọn loại", rows: ["Video", "Ảnh"], initialSelection: 0, doneBlock: { (picker, index, value) in
                if let type = value as? String {
                    self.txtType.text = type
                }
                if self.txtType.text == "Video" {
                    self.txtLinkVid.isUserInteractionEnabled = true
                    self.txtIndexVideo.isUserInteractionEnabled = true
                    self.imgCourse.isUserInteractionEnabled = false
                    self.courseImage = nil
                    self.imgCourse.image = UIImage(named: "placeholder")
                }
                
                if self.txtType.text == "Ảnh" {
                    self.imgCourse.isUserInteractionEnabled = true
                    self.txtLinkVid.isUserInteractionEnabled = false
                    self.txtIndexVideo.isUserInteractionEnabled = false
                    self.txtLinkVid.text = ""
                    self.txtIndexVideo.text = ""
                }
            }, cancel: nil, origin: txtType).show()
            return false
            
        case txtChooseCourse:
            
            if let indexObject = arrayNameCourse.firstIndex(of: "ALL COURSE") {
                arrayNameCourse.remove(at: indexObject)
            }
            
            ActionSheetStringPicker(title: "Chọn khoá học", rows: arrayNameCourse, initialSelection: 0, doneBlock: { (picker, index, value) in
                if let course = value as? String {
                    self.txtChooseCourse.text = course
                    self.getDataVideo(nameCourseChoose: course)
                }
            }, cancel: nil, origin: txtChooseCourse).show()
            return false
            
        default:
            return false
        }
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
