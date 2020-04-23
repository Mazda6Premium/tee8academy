//
//  GiftCourseVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/19/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class GiftCourseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrayFreeCourse = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupView()
    }
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func setupTableView() {
        let courseCell_xib = UINib(nibName: "BuyCourseCell", bundle: nil)
        tableView.register(courseCell_xib, forCellReuseIdentifier: "courseCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
    }
    
    @IBAction func tapOnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension GiftCourseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFreeCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! BuyCourseCell
        let course = arrayFreeCourse[indexPath.row]
        cell.backgroundColor = .clear
        cell.viewBackground.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
        cell.lblCourse.text = course.name
        cell.lblPrice.text = "Price: Free"
        cell.lblPrice.isHidden = true
        cell.imgDiscount.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
