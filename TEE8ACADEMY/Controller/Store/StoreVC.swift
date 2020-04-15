//
//  StoreVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/6/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import SDWebImage

class StoreVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNumberStore: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var widthConstr: NSLayoutConstraint!
    @IBOutlet weak var heightConstr: NSLayoutConstraint!
    
    var arrayProductPMU = [Product]()
    var arrayProductTimes = [Product]()
    var arrayCart = [Cart]()
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getDataFromFirebase()
        setUpCollectionView()
        setupRefreshControl()
        setupView()
    }
    
    func setupView() {
        roundCorner(views: [lblNumberStore], radius: 7.5)
        lblNumberStore.isHidden = true
    }
    
    func setupRefreshControl() {
        self.collectionView.alwaysBounceVertical = true
        self.refreshControl.tintColor = #colorLiteral(red: 0.1019607843, green: 0.3568627451, blue: 0.3921568627, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
    }
    
    @objc func reloadData() {
        arrayProductPMU.removeAll()
        arrayProductTimes.removeAll()
        collectionView.reloadData()
        getDataFromFirebase()
        refreshControl.endRefreshing()
    }
    
    func getDataFromFirebase() {
        showLoading()
        databaseReference.child("Products").observe(.childAdded) { (snapshot) in
            databaseReference.child("Products").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let product = Product(fromDict: dict)
                    
                    if product.type == "P.M.U PLUS" {
                        self.arrayProductPMU.append(product)
                    } else {
                        self.arrayProductTimes.append(product)
                    }
                    
                    self.collectionView.reloadData()
                    self.showLoadingSuccess(1)
                }
            }
        }
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let headerCell_xib = UINib(nibName: "HeaderCell", bundle: nil)
        collectionView.register(headerCell_xib, forCellWithReuseIdentifier: "headerCell")
        
        let productCell_xib = UINib(nibName: "VideoCell", bundle: nil)
        collectionView.register(productCell_xib, forCellWithReuseIdentifier: "videoCell")
    }
    
    @IBAction func tapOnCart(_ sender: Any) {
        if arrayCart.count > 0 {
            let vc = CheckOutVC(nibName: "CheckOutVC", bundle: nil)
            vc.arrayCart = self.arrayCart
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.delegateCheckOut = self
            self.present(vc, animated: true, completion: nil)
        } else {
            showToast(message: "Bạn chưa chọn sản phẩm nào")
        }
    }
}

extension StoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0 , 2 :
            return CGSize(width: screenWidth - 15, height: 46)
        case 1 , 3:
            return CGSize(width: screenWidth/2 - 15 , height: screenWidth/2 - 15)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension StoreVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return arrayProductPMU.count
        case 2:
            return 1
        case 3:
            return arrayProductTimes.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell0 = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCell
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
        cell0.backgroundColor = .clear
        cell0.imgDown.isHidden = true
        cell1.backgroundColor = .clear
        cell1.viewDim.isHidden = true
        cell1.imgLock.isHidden = true
        
        switch indexPath.section {
        case 0:
            cell0.btnTitle.setTitle("   P.M.U PLUS - WWW.PMUPLUS.COM", for: .normal)
            return cell0
        case 1:
            let productPMU = arrayProductPMU[indexPath.row]
            cell1.lblTitle.text = productPMU.name
            cell1.lblDescription.text = "Giá: \(formatMoney(productPMU.price)) VND"
            cell1.lblTime.isHidden = true
            if let url = URL(string: productPMU.imageUrl) {
                cell1.imgVideo.sd_setImage(with: url, completed: nil)
            } else {
                cell1.imgVideo.image = UIImage(named: "placeholder")
            }
            return cell1
        case 2:
            cell0.btnTitle.setTitle("   TIMES - WWW.PMUTIMES.COM", for: .normal)
            return cell0
        case 3:
            let productTime = arrayProductTimes[indexPath.row]
            cell1.lblTitle.text = productTime.name
            cell1.lblDescription.text = "Giá: \(formatMoney(productTime.price)) VND"
            cell1.lblTime.isHidden = true
            if let url = URL(string: productTime.imageUrl) {
                cell1.imgVideo.sd_setImage(with: url, completed: nil)
            } else {
                cell1.imgVideo.image = UIImage(named: "placeholder")
            }
            return cell1
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = BuyProductVC(nibName: "BuyProductVC", bundle: nil)
        switch indexPath.section {
        case 1:
            let product = arrayProductPMU[indexPath.row]
            vc.product = product
        case 3:
            let product = arrayProductTimes[indexPath.row]
            vc.product = product
        default:
            return
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.arrayCart = self.arrayCart
        self.present(vc, animated: true, completion: nil)
    }
}

extension StoreVC: BuyProductDelegate {
    func addToCart(cart: [Cart]) {
        lblNumberStore.text = "\(cart.count)"
        self.arrayCart = cart
        lblNumberStore.isHidden = false
        showLoadingSuccess(1)
    }
}

extension StoreVC: PopupCheckOutDelegate {
    func clearCart() {
        arrayCart.removeAll()
        lblNumberStore.text = "0"
        lblNumberStore.isHidden = true
    }
}

extension StoreVC: CheckOutDelegate {
    func deleteCart() {
        arrayCart.removeAll()
        lblNumberStore.text = "0"
        lblNumberStore.isHidden = true
    }
}
