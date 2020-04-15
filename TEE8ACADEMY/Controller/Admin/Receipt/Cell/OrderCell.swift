//
//  OrderCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage
import SimpleImageViewer

class OrderCell: FSPagerViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblRealName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblNumberProduct: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTotalPayment: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var order: Order! {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        lblRealName.text = order.realname
        lblUsername.text = "Username: \(order.username)"
        lblPhone.text = "Phone: \(order.phone)"
        lblAddress.text = "Address: \(order.address)"
        lblNumberProduct.text = "Number product: \(order.quantity)"
        lblTotalPayment.text = "Total payment \(formatMoney(order.totalPayment))"
        
        let time = order.time
        let date = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
        lblTime.text = date.timeAgoSinceDate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let views = [btnAccept, btnCancel, viewCell]
        views.forEach { (view) in
            view?.layer.cornerRadius = 10
            view?.layer.masksToBounds = true
        }

    }
}
