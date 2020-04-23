//
//  ProductCell.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let views = [imgProduct]
        views.forEach { (view) in
            view?.layer.cornerRadius = 10
            view?.layer.masksToBounds = true
        }
        
        addShadow(views: [viewCell])
        
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

}
