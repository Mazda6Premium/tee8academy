//
//  UserManagerCell.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class UserManagerCell: UITableViewCell {

    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewBlock: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundCorner(views: [viewUser , viewBlock], radius: 8)
        addShadow(views: [viewUser , viewBlock])
        setUpGes()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpGes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showEditCell))
        swipeLeft.direction = .left
        viewUser.isUserInteractionEnabled = true
        viewUser.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(hideEditCell))
        swipeRight.direction = .right
        viewUser.addGestureRecognizer(swipeRight)

    }
    
    @objc func showEditCell() {
        viewBlock.isHidden = false
        viewBlock.isUserInteractionEnabled = true
    }

    @objc func hideEditCell() {
        viewBlock.isHidden = true
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
