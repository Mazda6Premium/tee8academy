//
//  BaseViewController.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import Foundation
import Toast_Swift
import JGProgressHUD

class BaseViewController: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    
    func roundCorner(views: [UIView], radius: CGFloat) {
        views.forEach { (view) in
            view.layer.masksToBounds = true
            view.layer.cornerRadius = radius
        }
    }
    
    func addBorder(views: [UIView], width: CGFloat, color: CGColor) {
        views.forEach { (view) in
            view.layer.borderWidth = width
            view.layer.borderColor = color
        }
    }
    
    func showToast(message: String) {
        var style = ToastStyle()
        style.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
        style.messageColor = .white
        style.messageFont = UIFont(name: "Quicksand-Bold", size: 16)!
        self.view.makeToast(message, duration: 3, position: .bottom, style: style)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension BaseViewController {
    func showLoading(time: Double) {
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: time)
    }
    
    func showProgressLoading() {
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.detailTextLabel.text = "0% complete"
        hud.textLabel.text = "Uploading"
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.incrementHUD(self.hud, progress: 0)
        }
    }
    
    func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
        let progress = previousProgress + 1
        hud.progress = Float(progress)/100.0
        hud.detailTextLabel.text = "\(progress)% complete"
        
        if progress == 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                UIView.animate(withDuration: 0.1, animations: {
                    hud.textLabel.text = "Success"
                    hud.detailTextLabel.text = nil
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                
                hud.dismiss(afterDelay: 1.0)
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
                self.incrementHUD(hud, progress: progress)
            }
        }
    }
}
