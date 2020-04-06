//
//  StoreVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/6/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class StoreVC: UIViewController {
    
    @IBOutlet weak var imgAdmin: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapOnAdmin))
        imgAdmin.isUserInteractionEnabled = true
        imgAdmin.addGestureRecognizer(tapGes)
    }
    
    @objc func tapOnAdmin() {
        let vc = AdminPopupVC(nibName: "AdminPopupVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
