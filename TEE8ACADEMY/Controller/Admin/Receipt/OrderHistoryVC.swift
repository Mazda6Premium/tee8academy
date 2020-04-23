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
    
    var arrayOrder = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupPageView()
        getDataOrder()
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
        
        roundCorner(views: [pageView], radius: 10)
        
        let nib1 = UINib(nibName: "OrderCell", bundle: nil)
        pageView.register(nib1, forCellWithReuseIdentifier: "orderCell")
        pageView.transformer = FSPagerViewTransformer(type: .cubic)
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension OrderHistoryVC: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrayOrder.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "orderCell", at: index) as! OrderCell
        cell.backgroundColor = .clear
        cell.order = arrayOrder[index]
        cell.parentVC = self
        
        cell.btnAccept.isHidden = true
        cell.btnCancel.isHidden = true
        
        return cell
        
    }
}
