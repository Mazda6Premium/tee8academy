//
//  OrderHistoryVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/20/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FSPagerView

class OrderHistoryVC: BaseViewController {
    
    @IBOutlet weak var pageView: FSPagerView!
    @IBOutlet weak var pageViewCourse: FSPagerView!
    
    @IBOutlet weak var segmentedControl: SegmentedControl!
    
    var arrayOrder = [Order]()
    var arrayUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupPageView()
        getDataOrder()
        getDataCourse()
        setUpSegmentControl()
    }
    
    func getDataCourse() {
        showLoading()
        databaseReference.child("ReceiptSuccess").queryOrdered(byChild: "checkExists").queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                databaseReference.child("ReceiptSuccess").observe(.childAdded) { (snapshot) in
                    databaseReference.child("ReceiptSuccess").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                        if let dict = snapshot1.value as? [String: Any] {
                            let user = User.getUserData(dict: dict, key: snapshot1.key)
                            self.arrayUser.append(user)
                            self.pageViewCourse.reloadData()
                            
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
        
        databaseReference.child("OrdersSuccess").queryOrdered(byChild: "checkExists").queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                databaseReference.child("OrdersSuccess").observe(.childAdded) { (snapshot) in
                    databaseReference.child("OrdersSuccess").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                        if let dict = snapshot1.value as? [String: Any] {
                            let order = Order.getOrderData(dict: dict, key: snapshot1.key)
                            self.arrayOrder.append(order)
                            self.pageView.reloadData()
                            
                            self.showLoadingSuccess(1)
                        }
                    }
                }
            } else {
                self.hideLoading()
            }
        }
    }
    
    func setupPageView() {
        pageView.delegate = self
        pageView.dataSource = self
        pageView.isHidden = true
        roundCorner(views: [pageView, pageViewCourse], radius: 10)
        
        let nib1 = UINib(nibName: "OrderCell", bundle: nil)
        pageView.register(nib1, forCellWithReuseIdentifier: "orderCell")
        pageView.transformer = FSPagerViewTransformer(type: .cubic)
        
        pageViewCourse.delegate = self
        pageViewCourse.dataSource = self
        
        let nib = UINib(nibName: "RegisterAccountCell", bundle: nil)
        pageViewCourse.register(nib, forCellWithReuseIdentifier: "registerAccountCell")
        pageViewCourse.transformer = FSPagerViewTransformer(type: .cubic)
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpSegmentControl() {
        segmentedControl.selectedIndex = 0
        segmentedControl.items = ["Đơn hàng khoá học", "Đơn hàng sản phẩm"]
        segmentedControl.backgroundColor = .groupTableViewBackground
        segmentedControl.selectedLabelColor = .white
        segmentedControl.unselectedLabelColor = .black
        
        segmentedControl.borderColor = .clear
        segmentedControl.thumbColor = #colorLiteral(red: 0.1019607843, green: 0.3568627451, blue: 0.3921568627, alpha: 1)
        segmentedControl.font = UIFont.systemFont(ofSize: 16)
    }
    
    @IBAction func tapOnSegmented(_ sender: Any) {
        switch segmentedControl.selectedIndex {
        case 0:
            pageView.isHidden = true
            pageViewCourse.isHidden = false
        case 1:
            pageView.isHidden = false
            pageViewCourse.isHidden = true
        default:
            break
        }
    }
}

extension OrderHistoryVC: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == pageView {
            return arrayOrder.count
        } else {
            return arrayUser.count
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == pageView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "orderCell", at: index) as! OrderCell
            cell.backgroundColor = .clear
            cell.order = arrayOrder[index]
            cell.parentVC = self
            
            cell.btnAccept.isHidden = true
            cell.btnCancel.isHidden = true
            
            return cell
        } else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "registerAccountCell", at: index) as! RegisterAccountCell
            cell.user = arrayUser[index]
            cell.parentVC = self
            cell.backgroundColor = .clear
            cell.btnActive.isHidden = true
            cell.btnCancel.isHidden = true
            
            return cell
        }
    }
}
