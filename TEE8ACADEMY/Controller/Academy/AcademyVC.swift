//
//  AcademyVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/6/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import SDWebImage

class AcademyVC: BaseViewController {
    
    @IBOutlet weak var imgAdmin: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayCourse = [Course]()
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupCollectionView()
        getDataFromFirebase()
        setupRefreshControl()
    }
    
    func setupRefreshControl() {
        self.collectionView.alwaysBounceVertical = true
        self.refreshControl.tintColor = #colorLiteral(red: 0.1019607843, green: 0.3568627451, blue: 0.3921568627, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
    }
    
    @objc func reloadData() {
        getDataFromFirebase()
        refreshControl.endRefreshing()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let headerCell_xib = UINib(nibName: "HeaderCell", bundle: nil)
        collectionView.register(headerCell_xib, forCellWithReuseIdentifier: "headerCell")
        
        let productCell_xib = UINib(nibName: "VideoCell", bundle: nil)
        collectionView.register(productCell_xib, forCellWithReuseIdentifier: "videoCell")
    }
    
    func getDataFromFirebase() {
        showLoading()
        // DATA FOR COURSE
        databaseReference.child("Courses").observe(.childAdded) { (snapshot) in
            databaseReference.child("Courses").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let course = Course(fromDict: dict)
                    self.arrayCourse.append(course)
                    dump(self.arrayCourse)
                    self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                        return Int64(course1.price) > Int64(course2.price)
                    })
                    
                    self.arrayCourse.removeAll(where: { $0.name == "ALL COURSE" })
                    self.collectionView.reloadData()
                    self.showLoadingSuccess(1)
                }
            }
        }
    }
    
    func setupView() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapOnAdmin))
        imgAdmin.isUserInteractionEnabled = true
        imgAdmin.addGestureRecognizer(tapGes)
        
        if let user = SessionData.shared.userData {
            if user.email == "admin" {
                self.imgAdmin.isHidden = false
            } else {
                self.imgAdmin.isHidden = true
            }
        }
    }
    
    @objc func tapOnAdmin() {
        let vc = AdminPopupVC(nibName: "AdminPopupVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

extension AcademyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayCourse.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section % 2 == 0 {
            return 1
        } else {
            return arrayCourse[section / 2].video.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell0 = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCell
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
        
        cell0.backgroundColor = .clear
        cell1.backgroundColor = .clear
        
        if indexPath.section % 2 == 0 {
            let course = arrayCourse[indexPath.section / 2]
            cell0.btnTitle.setTitle("     \(course.name)", for: .normal)
            return cell0
        } else {
            let course = arrayCourse[indexPath.section / 2].video[indexPath.row]
            cell1.lblTitle.text = course.name
            cell1.lblDescription.text = course.description
            
            switch course.type {
            case "Video":
                if let videoId = getYoutubeId(youtubeUrl: course.linkVideo) {
                    // thumbnail
                    let urlString = "https://i1.ytimg.com/vi/\(String(describing: videoId))/hqdefault.jpg"
                    if let url = URL(string: urlString) {
                        cell1.imgVideo.sd_setImage(with: url, completed: nil)
                    } else {
                        cell1.imgVideo.image = UIImage(named: "placeholder")
                    }
                } else {
                    cell1.imgVideo.image = UIImage(named: "placeholder")
                }
            default:
                if let url = URL(string: course.imageUrl) {
                    cell1.imgVideo.sd_setImage(with: url, completed: nil)
                } else {
                    cell1.imgVideo.image = UIImage(named: "placeholder")
                }
            }

            return cell1
        }
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section % 2 == 0 {
            return CGSize(width: screenWidth, height: 46)
        } else {
            return CGSize(width: screenWidth/2 - 15 , height: screenWidth/2 - 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

