//
//  PopupEditVideo.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/18/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class PopupEditVideo: BaseViewController {
    
    @IBOutlet weak var viewDim: UIView!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtLinkVideo: UITextField!
    @IBOutlet weak var txtNameVideo: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnHuy: UIButton!
    @IBOutlet weak var btnXacNhan: UIButton!
    
    var video: Video?
    
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
        
        roundCorner(views: [viewDim, txtType, txtLinkVideo, txtNameVideo, tvDescription, btnHuy, btnXacNhan], radius: 8)
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnConfirm(_ sender: Any) {
        
    }
}
