//
//  RegisterAccountCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/7/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FSPagerView

class RegisterAccountCell: FSPagerViewCell {
    
    @IBOutlet weak var lblRealName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let views = [btnActive, btnCancel]
        views.forEach { (button) in
            button?.layer.cornerRadius = 8
            button?.layer.masksToBounds = true
        }
    }

}
