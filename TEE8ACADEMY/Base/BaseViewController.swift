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
    func showLoading() {
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    func showLoadingSuccess() {
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    func hideLoading() {
        hud.dismiss()
    }
}
