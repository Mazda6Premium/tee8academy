//
//  OrderCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class OrderCell: UICollectionViewCell {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
