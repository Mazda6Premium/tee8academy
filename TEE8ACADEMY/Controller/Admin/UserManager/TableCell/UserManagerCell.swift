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
    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    
    var user : User! {
        didSet {
            updateView()
            setUpGes()
        }
    }
    
    func updateView() {
        lblName.text = "Tên KH: \(user.username)"
        lblEmail.text = "Email: \(user.email)"
        lblPhone.text = "Phone \(user.phone)"
        viewBlock.isHidden = user.isSwiped
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView() {
        roundCorner(views: [viewUser , viewBlock], radius: 8)
        addShadow(views: [viewUser , viewBlock])
    }
    
    func setUpGes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showEditCell))
        swipeLeft.direction = .left
        viewUser.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(hideEditCell))
        swipeRight.direction = .right
        viewUser.addGestureRecognizer(swipeRight)

    }
    
    @objc func showEditCell() {
        user.isSwiped = false
        updateView()
    }

    @objc func hideEditCell() {
        user.isSwiped = true
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
