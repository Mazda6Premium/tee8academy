//
//  AdminPopupVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/6/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class AdminPopupVC: BaseViewController {
    
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var viewB: UIView!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var viewD: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewPopup, viewA, viewB, viewC, viewD], radius: 10)
        addBorder(views: [viewA, viewB, viewC, viewD], width: 1, color: #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1))
        
        let tapGes1 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewA))
        viewA.addGestureRecognizer(tapGes1)
        
        let tapGes2 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewB))
        viewB.addGestureRecognizer(tapGes2)
        
        let tapGes3 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewC))
        viewC.addGestureRecognizer(tapGes3)
        
        let tapGes4 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewD))
        viewD.addGestureRecognizer(tapGes4)
        
        let tapGes5 = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.addGestureRecognizer(tapGes5)
    }
    
    @objc func tapOnViewA() {
        UIView.animate(withDuration: 0.3) {
            self.viewA.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewA.alpha = 1
            }
        }
    }
    
    @objc func tapOnViewB() {
        UIView.animate(withDuration: 0.3) {
            self.viewB.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewB.alpha = 1
            }
        }
    }
    
    @objc func tapOnViewC() {
        UIView.animate(withDuration: 0.3) {
            self.viewC.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewC.alpha = 1
            }
        }
    }
    
    @objc func tapOnViewD() {
        UIView.animate(withDuration: 0.3) {
            self.viewD.alpha = 0.3
            UIView.animate(withDuration: 0.3) {
                self.viewD.alpha = 1
            }
        }
    }
    
    @objc func tapOnView() {
        dismiss(animated: true, completion: nil)
    }
}
