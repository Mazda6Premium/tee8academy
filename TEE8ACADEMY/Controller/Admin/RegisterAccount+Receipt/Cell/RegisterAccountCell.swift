//
//  RegisterAccountCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/7/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage
import SimpleImageViewer

class RegisterAccountCell: FSPagerViewCell {
    
    @IBOutlet weak var viewCell: UIView!
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
    @IBOutlet weak var imgPayment: UIImageView!
    
    var parentVC = UIViewController()
    
    var user: User! {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        lblRealName.text = user.realName
        
        let time = user.time
        let date = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
        lblTime.text = date.timeAgoSinceDate()
        
        lblUsername.text = "Username: \(user.username)"
        lblEmail.text = "Email: \(user.email)"
        
        lblPhone.text = "Phone: \(user.phone)"
        lblAddress.text = "Address: \(user.address)"
        
        var str = ""
        user.course.forEach { (course) in
            str += "\(course.name) "
        }
        lblCourse.text = "\(user.course.count) course: \(str)"
        
        lblPayment.text = "Payment method: \(user.paymentMethod)"
        lblTotal.text = "Payment: \(formatMoney(user.totalPayment)) VND"
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imgPayment.isUserInteractionEnabled = true
        imgPayment.addGestureRecognizer(tapGes)

        if let url = URL(string: user.imagePayment) {
            imgPayment.sd_setImage(with: url, completed: nil)
        } else {
            imgPayment.image = UIImage(named: "placeholder")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let views = [btnActive, btnCancel, imgPayment, viewCell]
        views.forEach { (view) in
            view?.layer.cornerRadius = 10
            view?.layer.masksToBounds = true
        }
        
        imgPayment.layer.borderWidth = 1
        imgPayment.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    }
    
    @objc func tapImage() {
        // show image
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imgPayment
        }
        let imageViewerController = ImageViewerController(configuration: configuration)
        parentVC.present(imageViewerController, animated: true, completion: nil)
    }
}
