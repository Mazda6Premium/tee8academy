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
    
    @IBOutlet weak var imgAdmin: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayProduct = [Product]()
    var arrayProductPMU = [Product]()
    var arrayProductTimes = [Product]()
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        getDataFromFirebase()
        setUpCollectionView()
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
    
    func setupView() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapOnAdmin))
        imgAdmin.isUserInteractionEnabled = true
        imgAdmin.addGestureRecognizer(tapGes)
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let headerCell_xib = UINib(nibName: "HeaderCell", bundle: nil)
        collectionView.register(headerCell_xib, forCellWithReuseIdentifier: "headerCell")
        
        let productCell_xib = UINib(nibName: "VideoCell", bundle: nil)
        collectionView.register(productCell_xib, forCellWithReuseIdentifier: "videoCell")
        
    }
    
    @objc func tapOnAdmin() {
        let vc = AdminPopupVC(nibName: "AdminPopupVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

extension StoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0 , 2 :
            return CGSize(width: screenWidth - 15, height: 50)
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
        
        
        switch indexPath.section {
        case 0:
            cell0.btnTitle.setTitle("P.M.U PLUS - WWW.PMUPLUS.COM", for: .normal)
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
            cell0.btnTitle.setTitle("TIMES - WWW.PMUTIMES.COM", for: .normal)
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
}
