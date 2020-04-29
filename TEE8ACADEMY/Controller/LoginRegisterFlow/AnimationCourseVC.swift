//
//  AnimationCourseVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/18/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class AnimationCourseVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFrame: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnGift: UIButton!
    
    var user: User?

    var lblTitle = UILabel()
    
    var arrayCourse = [Course]()
    var arrayFreeCourse = [Course]()
    var arrayChooseCourse = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setUpTableView()
        getDataFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationLabel()
    }
    
    func setupView() {
        changeAlpha(views: [self.btnContinue, self.btnSkip, self.tableView, self.btnGift], alpha: 0)
        roundCorner(views: [btnContinue, btnSkip], radius: 8)
        
        lblTitle.frame = CGRect(x: 30, y: screenHeight, width: lblFrame.frame.width, height: lblFrame.frame.height)
        lblTitle.numberOfLines = 0
        lblTitle.font = lblFrame.font
        lblTitle.textColor = lblFrame.textColor
        lblTitle.textAlignment = .center
        view.addSubview(lblTitle)

        user = SessionData.shared.userData
        if let user = user {
            lblTitle.text = "Welcome \(user.realName) to Tee 8 Academy, please choice your course belows:"

        }
        view.addSubview(lblTitle)
    }
    
    func animationLabel() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 2.5, animations: {
            self.lblTitle.frame = self.lblFrame.frame
            self.view.layoutIfNeeded()
        }) { (_) in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
                self.changeAlpha(views: [self.btnContinue, self.btnSkip, self.btnGift, self.tableView], alpha: 1)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        lblTitle.topAnchor.constraint(equalTo: lblFrame.topAnchor).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: lblFrame.leadingAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: lblFrame.trailingAnchor).isActive = true
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func changeAlpha(views : [UIView], alpha : CGFloat) {
        views.forEach { (view) in
            view.alpha = alpha
        }
    }
    
    func getDataFromFirebase() {
        showLoading()
        databaseReference.child("Courses").observe(.childAdded) { (snapshot) in
            databaseReference.child("Courses").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let course = Course(fromDict: dict)
                    if !course.isStoreCheck {
                        if course.price != 0 {
                            self.arrayCourse.append(course)
                            self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                                return Int64(course1.price) > Int64(course2.price)
                            })
                        } else {
                            self.arrayFreeCourse.append(course)
                        }
                    } else {
                        self.arrayCourse.append(course)
                        self.arrayCourse.removeAll(where: {$0.name == "ALL COURSE"})
                        self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                            return Int64(course1.price) > Int64(course2.price)
                        })
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
        if arrayCourse[0].isStoreCheck == false {
            if arrayChooseCourse.count != 0 {
                user?.course.append(contentsOf: arrayChooseCourse)
                user?.course.append(contentsOf: arrayFreeCourse)
                dump(user?.course)
                let vc = SendReceiptVC(nibName: "SendReceiptVC", bundle: nil)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.user = self.user
                self.present(vc, animated: true) {
                    self.arrayChooseCourse.removeAll()
                    self.arrayCourse.forEach { (course) in
                        course.isSelected = false
                    }
                    self.tableView.reloadData()
                }
            } else {
                showToast(message: "Bạn cần chọn ít nhất 1 khoá học có phí")
            }
        } else {
            let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func tapOnSkip(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapOnGift(_ sender: Any) {
        let vc = GiftCourseVC(nibName: "GiftCourseVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.arrayFreeCourse = self.arrayFreeCourse
        self.present(vc, animated: true, completion: nil)
    }
}

extension AnimationCourseVC: UITableViewDelegate,UITableViewDataSource {
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
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0.6392156863, green: 0, blue: 0, alpha: 1)
            cell.lblCourse.text = course.name
            cell.lblPrice.text = "Price: \(formatMoney(course.price)) VND"
            cell.imgDiscount.image = UIImage(named: "saving20")
            cell.imgDiscount.isHidden = false
            
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
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

