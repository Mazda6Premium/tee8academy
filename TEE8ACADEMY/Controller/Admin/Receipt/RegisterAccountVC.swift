//
//  RegisterAccount+Receipt.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/7/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FSPagerView
import FirebaseDatabase
import FirebaseStorage

class RegisterAccountVC: BaseViewController {
    
    @IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var pageView: FSPagerView!
    @IBOutlet weak var pageViewProducts: FSPagerView!
    
    var arrayUser = [User]()
    var arrayCourse = [Course]()
    
    var arrayOrder = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPageView()
        getDataFromFirebase()
        setUpSegmentControl()
    }
    
    func getDataFromFirebase() {
        showLoading()
        
        databaseReference.child("Receipts").queryOrdered(byChild: "checkExists").queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                databaseReference.child("Receipts").observe(.childAdded) { (snapshot) in
                    databaseReference.child("Receipts").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                        if let dict = snapshot1.value as? [String: Any] {
                            let user = User.getUserData(dict: dict, key: snapshot1.key)
                            self.arrayUser.append(user)
                            self.arrayUser.sort(by: { (user1, user2) -> Bool in
                                return Int64(user1.time) > Int64(user2.time)
                            })
                            self.getDataVideo()
                            DispatchQueue.main.async {
                                self.pageView.reloadData()
                            }
                            self.showLoadingSuccess(1)
                        }
                    }
                }
            } else {
                self.hideLoading()
            }
        }
    }
    
    func getDataOrder() {
        showLoading()
        
        databaseReference.child("Orders").queryOrdered(byChild: "checkExists").queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                databaseReference.child("Orders").observe(.childAdded) { (snapshot) in
                    databaseReference.child("Orders").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                        if let dict = snapshot1.value as? [String: Any] {
                            let order = Order.getOrderData(dict: dict, key: snapshot1.key)
                            self.arrayOrder.append(order)
                            DispatchQueue.main.async {
                                self.pageViewProducts.reloadData()
                            }
                            self.showLoadingSuccess(1)
                        }
                    }
                }
            } else {
                self.hideLoading()
            }
        }
    }
    
    func getDataVideo() {
        databaseReference.child("Users").observe(.childAdded) { (snapshot) in
            databaseReference.child("Users").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let user = User.getUserData(dict: dict, key: snapshot1.key)
                    self.arrayCourse = user.course
                }
            }
        }
    }
    
    func setUpSegmentControl() {
        segmentedControl.selectedIndex = 0
        segmentedControl.items = ["Đơn hàng khoá học", "Đơn hàng sản phẩm"]
        segmentedControl.backgroundColor = .groupTableViewBackground
        segmentedControl.selectedLabelColor = .white
        segmentedControl.unselectedLabelColor = .black
        
        segmentedControl.borderColor = .clear
        segmentedControl.thumbColor = #colorLiteral(red: 0.1019607843, green: 0.3568627451, blue: 0.3921568627, alpha: 1)
        segmentedControl.font = UIFont(name: "Quicksand-Bold", size: 16)
    }
    
    @IBAction func tapOnSegmented(_ sender: Any) {
        switch segmentedControl.selectedIndex {
        case 0:
            pageView.isHidden = false
            pageViewProducts.isHidden = true
        case 1:
            pageView.isHidden = true
            pageViewProducts.isHidden = false
        default:
            break
        }
    }
    
    
    func setupPageView() {
        pageView.delegate = self
        pageView.dataSource = self
        
        roundCorner(views: [pageView, pageViewProducts], radius: 10)
        
        let nib = UINib(nibName: "RegisterAccountCell", bundle: nil)
        pageView.register(nib, forCellWithReuseIdentifier: "registerAccountCell")
        pageView.transformer = FSPagerViewTransformer(type: .cubic)
        
        pageViewProducts.delegate = self
        pageViewProducts.dataSource = self
        let nib1 = UINib(nibName: "OrderCell", bundle: nil)
        pageViewProducts.register(nib1, forCellWithReuseIdentifier: "orderCell")
        pageViewProducts.transformer = FSPagerViewTransformer(type: .cubic)
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterAccountVC: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pageView == pageView {
            return arrayUser.count
        } else {
            return arrayOrder.count
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pageView == pageView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "registerAccountCell", at: index) as! RegisterAccountCell
            cell.user = arrayUser[index]
            cell.parentVC = self
            
            cell.btnActive.addTarget(self, action: #selector(tapOnActive), for: .touchUpInside)
            cell.btnActive.tag = index
            
            cell.btnCancel.addTarget(self, action: #selector(tapOnCancel), for: .touchUpInside)
            cell.btnCancel.tag = index
            
            return cell
        } else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "orderCell", at: index) as! OrderCell
            
        }
    }
    
    @objc func tapOnActive(sender: UIButton) {
        showLoading()
        let user = arrayUser[sender.tag]
        self.arrayCourse.append(contentsOf: user.course)
        let course = User(course: self.arrayCourse)
        databaseReference.child("Users").child(user.userId).updateChildValues(course.asDictionaryVideo())

        self.deleteImage(index: sender.tag)
        databaseReference.child("Receipt").child(user.receiptPostId).removeValue()

        self.arrayUser.removeAll()
        self.getDataFromFirebase()
        self.pageView.reloadData()
    }
    
    @objc func tapOnCancel(sender: UIButton) {
        showLoading()
        let user = arrayUser[sender.tag]
        deleteImage(index: sender.tag)
        databaseReference.child("Receipt").child(user.receiptPostId).removeValue()

        self.arrayUser.removeAll()
        self.getDataFromFirebase()
        self.pageView.reloadData()
    }
    
    func deleteImage(index: Int) {
        let url = arrayUser[index].imagePayment
        let storageRef = Storage.storage().reference(forURL: url)
        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                print(error)
            }
        }
    }
}
