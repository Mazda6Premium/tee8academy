//
//  RegisterAccount+Receipt.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/7/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FSPagerView

class RegisterAccountVC: UIViewController {
    
    @IBOutlet weak var pageView: FSPagerView!
    
    var arrayUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPageView()
    }
    
    func setupPageView() {
        pageView.delegate = self
        pageView.dataSource = self
        
        let nib = UINib(nibName: "PageViRegisterAccount+ReceiptCelldeoCell", bundle: nil)
        pageView.register(nib, forCellWithReuseIdentifier: "registerAccountCell")
        pageView.transformer = FSPagerViewTransformer(type: .cubic)
    }
}

extension RegisterAccountVC: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrayUser.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "registerAccountCell", at: index) as! RegisterAccountCell
        return cell
    }
}
