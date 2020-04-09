//
//  AcademyVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/6/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class AcademyVC: UIViewController {
    
    @IBOutlet weak var imgAdmin: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "HeaderCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "headerCell")
        
        
    }
    
    func setupView() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapOnAdmin))
        imgAdmin.isUserInteractionEnabled = true
        imgAdmin.addGestureRecognizer(tapGes)
        
        if let user = SessionData.shared.userData {
            print(user.email)
        }
    }
    
    @objc func tapOnAdmin() {
        let vc = AdminPopupVC(nibName: "AdminPopupVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
