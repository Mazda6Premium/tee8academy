//
//  HeaderCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/9/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var btnTitle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnTitle.layer.cornerRadius = 10
        btnTitle.layer.masksToBounds = true
    }

}
