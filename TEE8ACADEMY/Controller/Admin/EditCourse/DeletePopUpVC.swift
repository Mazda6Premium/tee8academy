//
//  DeletePopUpVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

protocol DeletePopUpDelegate {
    func refreshDataAfterDelete()
}

class DeletePopUpVC: BaseViewController {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var course : Course?
    var timer : Timer?
    var allCoursePrice = 0.0
    var sale = 0.2
    var delegate : DeletePopUpDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpView()
    }

    func setUpView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewPopUp , btnCancel , btnDelete], radius: 8)
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnDelete(_ sender: Any) {
        
        let priceAfterSale = self.allCoursePrice * (1 - self.sale)
        databaseReference.child("Courses").child("ALL COURSE").updateChildValues(["price" : priceAfterSale])
        databaseReference.child("Courses").child(course!.name).removeValue()
        startTimer()
        showLoadingSuccess(1)
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        
        delegate?.refreshDataAfterDelete()
        
        self.dismiss(animated: true, completion: nil)
        
        timer?.invalidate()
        timer = nil
    }

    
}
