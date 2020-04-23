//
//  PopupInfo.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/22/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class PopupInfo: BaseViewController {

    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var tvDes: UITextView!

    var des = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewPopup], radius: 8)
        
        tvDes.text = des
    }
}
