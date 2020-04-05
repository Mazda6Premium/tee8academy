//
//  BuyCourseVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class BuyCourseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayCourse = [
        Course(name: "ALL COURSE", price: 40000000),
        Course(name: "PHOENIXBROWS", price: 10000000),
        Course(name: "MICROBLADING", price: 8000000),
        Course(name: "SWINGBROWS", price: 8000000),
        Course(name: "QUICKLIPS", price: 8000000),
        Course(name: "REMOVAL", price: 8000000),
        Course(name: "ALL PMU THEORY", price: 0),
        Course(name: "COLOR SCHEMES", price: 0),
        Course(name: "PROFESSIONAL TOOLKIT", price: 0)
    ]
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpTableView()
    }
    
    func setUpTableView() {
        let courseCell_xib = UINib(nibName: "BuyCourseCell", bundle: nil)
        tableView.register(courseCell_xib, forCellReuseIdentifier: "courseCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
    }
    
}

extension BuyCourseVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! BuyCourseCell
        switch indexPath.row {
        case 0:
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0.6392156863, green: 0, blue: 0, alpha: 1)
            cell.lblPrice.text = "\(arrayCourse[0].price)"
            cell.lblCourse.text = arrayCourse[0].name
        default:
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.6549019608, blue: 0.8784313725, alpha: 1)
            cell.lblCourse.text = arrayCourse[indexPath.row].name
            cell.lblPrice.text = "\(arrayCourse[indexPath.row].price)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BuyCourseCell
        cell.selectionStyle = .none
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            cell.viewBackgroundWidth.constant = self.screenWidth - 40
            self.view.layoutIfNeeded()
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BuyCourseCell
        cell.selectionStyle = .none
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            cell.viewBackgroundWidth.constant = 10
            self.view.layoutIfNeeded()
        }
    }
}
