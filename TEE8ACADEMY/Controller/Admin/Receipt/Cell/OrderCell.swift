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
//    @IBOutlet weak var btnAccept: UIButton!
//    @IBOutlet weak var btnCancel: UIButton!
    
    var arrayCart = [Cart]()
    var parentVC = UIViewController()
    
    var order: Order! {
        didSet {
            updateView()
            
            arrayCart = order.cart
            collectionView.reloadData()
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
        let views = [viewCell]
        views.forEach { (view) in
            view?.layer.cornerRadius = 10
            view?.layer.masksToBounds = true
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "productCell")
    }
}

extension OrderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        let cart = arrayCart[indexPath.row]
        cell.lblProductName.text = "Sản phẩm: \(cart.name)"
        cell.lblQuantity.text = "Số lượng: \(cart.quantity)"
        let totalPrice = cart.price * Double(cart.quantity)
        cell.lblPrice.text = "Tổng tiền: \(formatMoney(totalPrice)) VND"
        
        if let url = URL(string: cart.imageUrl) {
            cell.imgProduct.sd_setImage(with: url, completed: nil)
        } else {
            cell.imgProduct.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCell
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.imgProduct
        }
        parentVC.present(ImageViewerController(configuration: configuration), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.frame.width > 30 {
            return CGSize(width: self.frame.width - 30, height: 140)
        } else {
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
