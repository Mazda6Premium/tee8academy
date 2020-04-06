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
    

    var arrayChooseCourse = [Course]()
    
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setUpTableView()
    }
    
    func setupView() {
        roundCorner(views: [btnContinue, btnSupport, btnBack], radius: 8)
        
        if let user = user {
            lblTitle.text = "Welcome \(user.realName) to Tee 8 Academy, please choice your course belows:"
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
        view.endEditing(true)
        if arrayChooseCourse.count != 0 {
            user?.course.append(contentsOf: arrayChooseCourse)
            print(user?.asDictionary())
            let vc = SendReceiptVC(nibName: "SendReceiptVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.user = self.user
            self.present(vc, animated: true, completion: nil)
        } else {
            showToast(message: "Bạn cần chọn ít nhất 1 khoá học")
        }
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension BuyCourseVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! BuyCourseCell
        cell.backgroundColor = .clear
        let totalRows = arrayCourse.count

        switch indexPath.row {
        case 0:
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0.6392156863, green: 0, blue: 0, alpha: 1)
            let course = arrayCourse[0]
            cell.lblCourse.text = course.name
            cell.lblPrice.text = "Price: \(formatMoney(course.price)) VND"
            cell.imgDiscount.image = UIImage(named: "saving20")
            cell.imgDiscount.isHidden = false
            
            // RUN ANIMATION IN FIRST CASE
            switch course.isSelected {
            case true:
                animationRunCell(cell: cell)
            case false:
                animationBackCell(cell: cell)
            }
        
        case 1..<totalRows-3 :
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
            let course = arrayCourse[indexPath.row]
            cell.lblCourse.text = course.name
            cell.lblPrice.text = "Price: \(formatMoney(course.price)) VND"
            cell.imgDiscount.isHidden = true
            
            // RUN ANIMATION IN 1...6 CASE
            switch course.isSelected {
            case true:
                animationRunCell(cell: cell)
            case false:
                animationBackCell(cell: cell)
            }
            
        default:
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
            let course = arrayCourse[indexPath.row]
            cell.lblCourse.text = course.name
            cell.lblPrice.text = "Tặng kèm"
            cell.imgDiscount.isHidden = true
        }
        
        return cell
    }
    
    func animationRunCell(cell: BuyCourseCell) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            cell.viewBackgroundWidth.constant = self.screenWidth - 40
            cell.lblCourse.textColor = .white
            cell.lblPrice.textColor = .white
            self.view.layoutIfNeeded()
        }
    }
    
    func animationBackCell (cell: BuyCourseCell) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
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
            if course.isSelected == true { // DIDSELECT AND REMOVE
                course.isSelected = false
                tableView.reloadData()

                if let indexObject = arrayChooseCourse.firstIndex(where: {$0.name == "All COURSE"}) {
                    arrayChooseCourse.remove(at: indexObject)
                }
            } else { // SELECT AND APPEND
                course.isSelected = true
                for row in 1...totalRows-3 {
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
        case 1..<totalRows-3: // 1...6 CASE
            if course.isSelected == true { // DIDSELECT AND REMOVE
                course.isSelected = false
                tableView.reloadData()

                
                let courseName = arrayCourse[indexPath.row].name
                if let indexObject = arrayChooseCourse.firstIndex(where: {$0.name == courseName}) {
                    arrayChooseCourse.remove(at: indexObject)
                }
                
            } else { //SELECT AND APPEND
                course.isSelected = true
                arrayCourse[0].isSelected = false
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

        default:
            break
        }
        

        dump(arrayChooseCourse)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
