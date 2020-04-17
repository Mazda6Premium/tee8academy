//
//  EditCourseVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/14/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class EditCourseVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var arrayCourse = [Course]()
    var allCoursePrice = 0.0
    var timer : Timer?
    var sale : Double = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpTableView()
        getDataFromFirebase()
    }
    
    func setUpTableView() {
        let editCourseCell_xib = UINib(nibName: "EditCourseCell", bundle: nil)
        tableView.register(editCourseCell_xib, forCellReuseIdentifier: "editCourseCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func getDataFromFirebase() {
        showLoading()
        databaseReference.child("Courses").observe(.childAdded) { (snapshot) in
            databaseReference.child("Courses").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let course = Course(fromDict: dict)
                    if course.name == "ALL COURSE" {
                        self.allCoursePrice = course.price
                    }
                    
                    self.arrayCourse.append(course)
                    self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                        return Int64(course1.price) > Int64(course2.price)
                    })
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.showLoadingSuccess(1)
                }
            }
        }
    }
    @IBAction func tapOnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension EditCourseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCourse.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCourseCell") as! EditCourseCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let course = arrayCourse[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.course = course
            cell.viewCourse.backgroundColor = #colorLiteral(red: 0.6392156863, green: 0, blue: 0, alpha: 1)
            cell.lblPrice.textColor = .white
            cell.lblCourse.textColor = .white
//            cell.lblCourse.text = course.name
//            cell.lblPrice.text = "Price: \(formatMoney(course.price)) VND"
            cell.imgDiscount.image = UIImage(named: "saving20")
            cell.imgDiscount.isHidden = false
            cell.isUserInteractionEnabled = false
            
        default :
            cell.course = course

            cell.viewCourse.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
            cell.viewEdit.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
            cell.viewDelete.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)

            cell.lblPrice.textColor = .white
            cell.lblCourse.textColor = .white
            cell.imgDiscount.isHidden = true
            
            cell.viewEdit.tag = indexPath.row
            cell.viewDelete.tag = indexPath.row
            
            let tapGes1 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewDel))
            cell.viewDelete.addGestureRecognizer(tapGes1)
            
            let tapGes2 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewEdit))
            cell.viewEdit.addGestureRecognizer(tapGes2)
        }
        
        return cell
    }
    
    @objc func tapOnViewDel(_ sender : UITapGestureRecognizer) {
        if let index = sender.view?.tag {
            
            let vc = DeletePopUpVC(nibName: "DeletePopUpVC", bundle: nil)
            let course = arrayCourse[index]
            vc.course = course
            vc.allCoursePrice = allCoursePrice / (1 - sale) - course.price
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func tapOnViewEdit(_ sender : UITapGestureRecognizer) {
        if let index = sender.view?.tag {
            let vc = EditPopUpVC(nibName: "EditPopUpVC", bundle: nil)
            let course = arrayCourse[index]
            vc.allCoursePrice = allCoursePrice / (1 - sale) - course.price
            vc.course = course
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}

extension EditCourseVC : EditPopUpDelegate {
    func refreshData() {
        self.arrayCourse.removeAll()
        self.tableView.reloadData()
        getDataFromFirebase()
    }    
}

extension EditCourseVC : DeletePopUpDelegate {
    func refreshDataAfterDelete() {
        self.arrayCourse.removeAll()
        self.tableView.reloadData()
        getDataFromFirebase()
    }
}
