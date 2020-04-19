//
//  PopupEditVideo.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/18/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import Firebase

protocol PopupEditVideoDelegate {
    func reloadData()
}

class PopupEditVideo: BaseViewController {
    
    @IBOutlet weak var viewDim: UIView!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtLinkVideo: UITextField!
    @IBOutlet weak var txtNameVideo: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnXoa: UIButton!
    @IBOutlet weak var btnXacNhan: UIButton!
    @IBOutlet weak var viewLinkVideo: UIView!
    
    var video: Video?
    var timer : Timer?
    var delegate : PopupEditVideoDelegate?
    var arrayVideo = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpView()
        bindData()
    }
    
    func bindData() {
        if let data = video {
            txtType.text = data.type
            txtNameVideo.text = data.name
            if data.type == "Video" {
                txtLinkVideo.text = data.linkVideo
            } else {
                txtLinkVideo.isHidden = true
            }
            tvDescription.text = data.description
        }
    }
    
    func setUpView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewDim, txtType, viewLinkVideo, txtNameVideo, tvDescription, btnXoa, btnXacNhan], radius: 8)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnConfirm(_ sender: Any) {
        showLoading()
        if txtLinkVideo.text == "" || txtNameVideo.text == "" || tvDescription.text == "" {
            showToast(message: "Bạn cần điền đẩy đủ thông tin.")
            hideLoading()
        } else {
            let values = ["description": tvDescription.text!, "name": txtNameVideo.text!, "linkVideo": txtLinkVideo.text!] as [AnyHashable : Any]
            if let vid = video {
                databaseReference.child("Courses").child(vid.course).observe(.childAdded) { (data) in
                    databaseReference.child("Courses").child(vid.course).child(data.key).queryOrdered(byChild: "id").queryEqual(toValue: vid.id).observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.exists() {
                            self.hideLoading()
                            for child in snapshot.children {
                                guard let data = child as? DataSnapshot else {return}
                                databaseReference.child("Courses").child(vid.course).child("videos").child(data.key).updateChildValues(values)
                                self.startTimer()
                                self.showLoadingSuccess(1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        delegate?.reloadData()
        self.dismiss(animated: true, completion: nil)
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func tapOnXoa(_ sender: Any) {
        if let vid = video {
            self.arrayVideo.removeAll(where: { $0.id == vid.id})
            databaseReference.child("Courses").child(vid.course).observe(.childAdded) { (data) in
                databaseReference.child("Courses").child(vid.course).child(data.key).queryOrdered(byChild: "id").queryEqual(toValue: vid.id).observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.exists() {
                        self.hideLoading()
                        for child in snapshot.children {
                            guard let data = child as? DataSnapshot else {return}
                            databaseReference.child("Courses").child(vid.course).child("videos").child(data.key).removeValue()
                            
                            let course = Course(video: self.arrayVideo)
                            databaseReference.child("Courses").child(vid.course).updateChildValues(course.asDictionaryVideo())
                            self.startTimer()
                            self.showLoadingSuccess(1)
                        }
                    }
                }
            }
        }
    }
}
