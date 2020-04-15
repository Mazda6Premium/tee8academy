//
//  CheckOutCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/14/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class CheckOutCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnTru: UIButton!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnCong: UIButton!
    
    var decrease: ((_ index: Int) -> Void)?
    var increase: ((_ index: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addShadow(views: [viewCell])
        
        imgProduct.layer.cornerRadius = 8
        imgProduct.layer.masksToBounds = true
        imgProduct.layer.borderWidth = 1
        imgProduct.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapOnTru(_ sender: Any) {
        decrease?(btnTru.tag)
    }
    
    @IBAction func tapOnCong(_ sender: Any) {
        increase?(btnCong.tag)
    }
    
}
