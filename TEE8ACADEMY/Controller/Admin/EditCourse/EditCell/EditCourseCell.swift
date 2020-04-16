//
//  EditCourseCell.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class EditCourseCell: UITableViewCell {

    @IBOutlet weak var viewCourse: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgDiscount: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewEdit.isHidden = true
        viewDelete.isHidden = true
        
        roundCorner(views: [viewCourse , viewEdit , viewDelete], radius: 8)
        addShadow(views: [viewCourse , viewEdit , viewDelete])
        setUpGes()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func setUpGes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showEditCell))
        swipeLeft.direction = .left
        viewCourse.isUserInteractionEnabled = true
        viewCourse.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(hideEditCell))
        swipeRight.direction = .right
        viewCourse.addGestureRecognizer(swipeRight)

    }
    
    @objc func showEditCell() {
        viewDelete.isHidden = false
        viewEdit.isHidden = false
        
        viewDelete.isUserInteractionEnabled = true
        viewEdit.isUserInteractionEnabled = true
        
    }

    @objc func hideEditCell() {
        viewDelete.isHidden = true
        viewEdit.isHidden = true
    }
    
    func roundCorner(views: [UIView], radius: CGFloat) {
        views.forEach { (view) in
            view.layer.masksToBounds = true
            view.layer.cornerRadius = radius
        }
    }
    
    func addShadow(views: [UIView]) {
        views.forEach { (view) in
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            view.layer.shadowOpacity = 0.5
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowColor = UIColor.darkGray.cgColor
            view.clipsToBounds = false
            view.backgroundColor = .white
        }
    }
    
    override func prepareForReuse() {
        hideEditCell()
    }
}
