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
    
        // ROUND CORNER
        
        imgVideo.layer.cornerRadius = 10
        imgVideo.clipsToBounds = true
        
        addShadow(views: [viewCell])
    }

}

func addShadow(views: [UIView]) {
    views.forEach { (view) in
        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.clipsToBounds = true
        view.backgroundColor = .white
    }
}
