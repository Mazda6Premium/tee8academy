//
//  BlockPopUpVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/17/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

protocol BlockPopUpDelegate {
    func updateUserStatus()
}

enum StatusUser {
    case block
    case unBlock
}

class BlockPopUpVC: BaseViewController {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnBlock: UIButton!
    
    var statusUser : StatusUser?
    var user : User?
    var timer : Timer?
    var delegate : BlockPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpView()
    }

    func setUpView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        roundCorner(views: [viewPopUp , btnCancel , btnBlock], radius: 8)
        
        switch statusUser {
        case .block:
            lblMessage.text = "Bạn có chắc chắn muốn bỏ khoá user này không ?"
            btnBlock.setTitle("Bỏ chặn", for: .normal)
        case .unBlock:
            lblMessage.text = "Bạn có chắc chắn muốn khoá user này không ?"
            btnBlock.setTitle("Chặn", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func tapOnBlock(_ sender: Any) {
        switch statusUser {
        case .block:
            let isBlock = false
            databaseReference.child("Users").child(user!.userId).updateChildValues(["isBlock" : isBlock])
            startTimer()
            showLoadingSuccess(1)
        case .unBlock:
            let isBlock = true
            databaseReference.child("Users").child(user!.userId).updateChildValues(["isBlock" : isBlock])
            startTimer()
            showLoadingSuccess(1)
        default:
            break
        }
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearData), userInfo: nil, repeats: true)
    }
    
    @objc func clearData() {
        
        delegate?.updateUserStatus()
        
        self.dismiss(animated: true, completion: nil)
        
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
