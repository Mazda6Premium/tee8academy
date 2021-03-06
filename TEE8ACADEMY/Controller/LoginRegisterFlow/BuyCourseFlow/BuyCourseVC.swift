//
//  BuyCourseVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class BuyCourseVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var user: User?
    
    var arrayCourse = [Course]()
    var arrayFreeCourse = [Course]()
    var arrayChooseCourse = [Course]()
    var alreadyBuyCourse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setUpTableView()
        getDataFromFirebase()
    }
    
    func setupView() {
        roundCorner(views: [btnContinue, btnSupport, btnBack], radius: 8)
        
        user = SessionData.shared.userData
        if let user = user {
            lblTitle.text = "Welcome \(user.realName) to Tee 8 Academy, please choice your course belows:"
            if user.course.count > 0 {
                alreadyBuyCourse = true
            }
        }
    }
    
    func getDataFromFirebase() {
        showLoading()
        databaseReference.child("Courses").observe(.childAdded) { (snapshot) in
            databaseReference.child("Courses").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let course = Course(fromDict: dict)
                    if course.price != 0 {
                        self.arrayCourse.append(course)
                        self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                            return Int64(course1.price) > Int64(course2.price)
                        })
                        
                        if let buyCourse = SessionData.shared.userData?.course {
                            if buyCourse.count > 0 {
                                self.arrayCourse.removeAll(where: {$0.name == "ALL COURSE"})
                                buyCourse.forEach { (value) in
                                    self.arrayCourse.removeAll(where: {$0.name == value.name})
                                }
                            }

                        }
                    } else {
                        self.arrayFreeCourse.append(course)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.showLoadingSuccess(1)
                }
            }
        }
    }
    
    func setUpTableView() {
        let courseCell_xib = UINib(nibName: "BuyCourseCell", bundle: nil)
        tableView.register(courseCell_xib, forCellReuseIdentifier: "courseCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
    }
    
    @IBAction func tapOnContinue(_ sender: Any) {
        user?.course.removeAll()
        view.endEditing(true)
        if arrayChooseCourse.count != 0 {
            if !alreadyBuyCourse {
                user?.course.append(contentsOf: arrayFreeCourse)
            }
            user?.course.append(contentsOf: arrayChooseCourse)
            dump(user?.course)
            if !arrayChooseCourse[0].isStoreCheck {
                let vc = SendReceiptVC(nibName: "SendReceiptVC", bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.user = self.user
                vc.caseReceipt = .buy
                self.present(vc, animated: true) {
                    self.arrayChooseCourse.removeAll()
                    self.arrayCourse.forEach { (course) in
                        course.isSelected = false
                    }
                    self.tableView.reloadData()
                }
            } else {
                let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC")
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } else {
            showToast(message: "Bạn cần chọn ít nhất 1 khoá học có phí")
        }
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnGift(_ sender: Any) {
        let vc = GiftCourseVC(nibName: "GiftCourseVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.arrayFreeCourse = self.arrayFreeCourse
        self.present(vc, animated: true, completion: nil)
    }
}

extension BuyCourseVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! BuyCourseCell
        cell.backgroundColor = .clear
        let course = arrayCourse[indexPath.row]
        switch course.isSelected {
        case true:
            animationRunCell(cell: cell)
        case false:
            animationBackCell(cell: cell)
        }
        cell.lblPrice.isHidden = true
        
        switch indexPath.row {
        case 0:
            if course.name == "ALL COURSE" {
                cell.viewBackground.backgroundColor = #colorLiteral(red: 0.6392156863, green: 0, blue: 0, alpha: 1)
                cell.lblCourse.text = course.name
                cell.lblPrice.text = "Price: \(formatMoney(course.price)) VND"
                cell.imgDiscount.image = UIImage(named: "saving20")
                cell.imgDiscount.isHidden = false
            } else {
                cell.viewBackground.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
                cell.lblCourse.text = course.name
                cell.lblPrice.text = "Price: \(formatMoney(course.price)) VND"
                cell.imgDiscount.isHidden = true
            }
            
        default :
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
            cell.lblCourse.text = course.name
            cell.lblPrice.text = "Price: \(formatMoney(course.price)) VND"
            cell.imgDiscount.isHidden = true
        }
        return cell
    }
    
    func animationRunCell(cell: BuyCourseCell) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            cell.viewBackgroundWidth.constant = self.screenWidth - 40
            cell.lblCourse.textColor = .white
            cell.lblPrice.textColor = .white
            self.view.layoutIfNeeded()
        }
    }
    
    func animationBackCell (cell: BuyCourseCell) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            cell.viewBackgroundWidth.constant = 10
            cell.lblCourse.textColor = .black
            cell.lblPrice.textColor = .black
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalRows = arrayCourse.count
        let course = arrayCourse[indexPath.row]
        let chooseCourse = Course(name: course.name, price: course.price)
        
        switch indexPath.row {
        case 0: // FIRST CASE
            if course.name == "ALL COURSE" {
                if course.isSelected == true { // DIDSELECT AND REMOVE
                    course.isSelected = false
                    tableView.reloadData()
                    
                    if let indexObject = arrayChooseCourse.firstIndex(where: {$0.name == "All COURSE"}) {
                        arrayChooseCourse.remove(at: indexObject)
                    }
                } else { // SELECT AND APPEND
                    course.isSelected = true
                    for row in 1..<totalRows {
                        arrayCourse[row].isSelected = false
                        tableView.reloadData()
                    }
                    
                    if arrayChooseCourse.isEmpty {
                        arrayChooseCourse.append(chooseCourse)
                    } else {
                        arrayChooseCourse.removeAll()
                        arrayChooseCourse.append(chooseCourse)
                    }
                }
            } else {
                if course.isSelected == true { // DIDSELECT AND REMOVE
                    course.isSelected = false
                    tableView.reloadData()
                    
                    let courseName = arrayCourse[indexPath.row].name
                    if let indexObject = arrayChooseCourse.firstIndex(where: {$0.name == courseName}) {
                        arrayChooseCourse.remove(at: indexObject)
                    }
                } else { //SELECT AND APPEND
                    course.isSelected = true
//                    arrayCourse[0].isSelected = false
                    tableView.reloadData()
                    if arrayChooseCourse.isEmpty {
                        arrayChooseCourse.append(chooseCourse)
                    } else {
                        if let indexObject = arrayChooseCourse.firstIndex(where: {$0.name == "ALL COURSE"}) {
                            arrayChooseCourse.remove(at: indexObject)
                        }
                        arrayChooseCourse.append(chooseCourse)
                    }
                }
            }

        default:
            if course.isSelected == true { // DIDSELECT AND REMOVE
                course.isSelected = false
                tableView.reloadData()
                
                let courseName = arrayCourse[indexPath.row].name
                if let indexObject = arrayChooseCourse.firstIndex(where: {$0.name == courseName}) {
                    arrayChooseCourse.remove(at: indexObject)
                }
            } else { //SELECT AND APPEND
                course.isSelected = true
                if arrayCourse[0].name == "ALL COURSE" {
                    arrayCourse[0].isSelected = false
                }
                tableView.reloadData()
                if arrayChooseCourse.isEmpty {
                    arrayChooseCourse.append(chooseCourse)
                } else {
                    if let indexObject = arrayChooseCourse.firstIndex(where: {$0.name == "ALL COURSE"}) {
                        arrayChooseCourse.remove(at: indexObject)
                    }
                    arrayChooseCourse.append(chooseCourse)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
