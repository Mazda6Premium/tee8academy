//
//  VideoCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/9/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
