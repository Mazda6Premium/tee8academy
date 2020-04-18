//
//  EditVideoVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/18/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class EditVideoVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayCourse = [Course]()
    var screenWidthVideo: CGFloat = 0.1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCollectionView()
        getDataFromFirebase()
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
                    self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                        return Int64(course1.price) > Int64(course2.price)
                    })
                    
                    self.arrayCourse.removeAll(where: { $0.name == "ALL COURSE"})
                    if self.arrayCourse.count > 0 {
                        self.arrayCourse[0].isOpen = true
                    }
                    
                    self.collectionView.reloadData()
                    self.showLoadingSuccess(1)
                }
            }
        }
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditVideoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        if arrayCourse[indexPath.section / 2].video.count > 0 {
            cell0.imgDown.isHidden = false
        } else {
            cell0.imgDown.isHidden = true
        }
        
//        let data = arrayCourse[indexPath.section / 2]
        cell1.viewDim.isHidden = true
        cell1.imgLock.isHidden = true
//        if !data.isUnLock {
//            cell1.isUserInteractionEnabled = false
//        } else {
//            cell1.isUserInteractionEnabled = true
//        }
        
        if indexPath.section % 2 == 0 {
            let course = arrayCourse[indexPath.section / 2]
            cell0.btnTitle.setTitle("     \(course.name)", for: .normal)
            return cell0
        } else {
            let course = arrayCourse[indexPath.section / 2].video[indexPath.row]
            cell1.lblTitle.text = course.name
            cell1.lblDescription.text = course.description
            if course.type == "Video" {
                cell1.lblTime.isHidden = true
            } else {
                cell1.lblTime.isHidden = true
            }
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section % 2 != 0 {
            let course = arrayCourse[indexPath.section / 2].video[indexPath.row]
            let vc = PopupEditVideo(nibName: "PopupEditVideo", bundle: nil)
            vc.modalPresentationStyle = .overCurrentContext
            vc.video = course
            vc.delegate = self
            vc.arrayVideo = arrayCourse[indexPath.section / 2].video
            self.present(vc, animated: true, completion: nil)
        } else { // TAP ON HEADER
            collectionView.performBatchUpdates({
                let course = arrayCourse[indexPath.section / 2]
                course.isOpen = !course.isOpen
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section % 2 == 0 {
            return CGSize(width: screenWidth, height: 46)
        } else {
            let course = arrayCourse[indexPath.section / 2]
            if course.isOpen {
                screenWidthVideo = UIScreen.main.bounds.size.width / 2 - 15
            } else {
                screenWidthVideo = 0.1
            }
            
            return CGSize(width: screenWidthVideo, height: screenWidthVideo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension EditVideoVC: PopupEditVideoDelegate {
    func reloadData() {
        self.arrayCourse.removeAll()
        collectionView.reloadData()
        getDataFromFirebase()
    }
}
