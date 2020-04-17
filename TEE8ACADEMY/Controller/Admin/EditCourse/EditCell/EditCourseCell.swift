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
    
    var course : Course! {
        didSet {
            updateView()
            setUpGes()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        roundCorner(views: [viewCourse , viewEdit , viewDelete], radius: 8)
        addShadow(views: [viewCourse , viewEdit , viewDelete])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func updateView() {
        lblCourse.text = course.name
        lblPrice.text = "Price: \(formatMoney(course.price)) VND"
        viewEdit.isHidden = course.isSwiped
        viewDelete.isHidden = course.isSwiped
    }
    
    func setUpGes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showEditCell))
        swipeLeft.direction = .left
        viewCourse.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(hideEditCell))
        swipeRight.direction = .right
        viewCourse.addGestureRecognizer(swipeRight)

    }
    
    @objc func showEditCell() {
        course.isSwiped = false
        updateView()
    }

    @objc func hideEditCell() {
        course.isSwiped = true
        updateView()
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
    
}
