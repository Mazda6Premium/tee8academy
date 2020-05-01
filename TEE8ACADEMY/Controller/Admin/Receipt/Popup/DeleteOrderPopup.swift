//
//  DeleteOrderPopup.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/20/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import Firebase

protocol DeleteOrderDelegate {
    func reloadData()
}

class DeleteOrderPopup: BaseViewController {

    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var order: Order?
    var delegate: DeleteOrderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewPopup, btnCancel, btnDelete], radius: 8)
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnDelete(_ sender: Any) {
        showLoading()
        if let data = order {
            databaseReference.child("Orders").child(data.orderId).removeValue()
            self.delegate?.reloadData()
            showLoadingSuccess()
            dismiss(animated: true, completion: nil)
        }
    }
}
