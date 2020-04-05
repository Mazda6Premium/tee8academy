//
//  BuyCourseCell.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class BuyCourseCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewBackgroundWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackground.layer.masksToBounds = true
        viewBackground.layer.cornerRadius = 10
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

