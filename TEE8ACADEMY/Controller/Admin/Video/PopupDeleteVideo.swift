//
//  PopupDeleteVideo.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/20/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class PopupDeleteVideo: BaseViewController {
    
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewPopup, btnCancel, btnDelete], radius: 8)
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnDelete(_ sender: Any) {
        showLoading()

    }
}
