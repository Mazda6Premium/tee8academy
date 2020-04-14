//
//  AcademyVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/6/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import SDWebImage
import XCDYouTubeKit
import AVKit
import SimpleImageViewer

struct VideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

class AcademyVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayCourse = [Course]()
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    var screenWidthVideo: CGFloat = 0.1
    var courseRegisted = [Course]()

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        bindData()
        getDataFromFirebase()
        setupRefreshControl()
        
    }
    
    func bindData() {
        if let user = SessionData.shared.userData {
            courseRegisted = user.course
        }
    }
    
    func setupRefreshControl() {
        self.collectionView.alwaysBounceVertical = true
        self.refreshControl.tintColor = #colorLiteral(red: 0.1019607843, green: 0.3568627451, blue: 0.3921568627, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
    }
    
    @objc func reloadData() {
        arrayCourse.removeAll()
        collectionView.reloadData()
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
                    self.arrayCourse.sort(by: { (course1, course2) -> Bool in
                        return Int64(course1.price) > Int64(course2.price)
                    })
                    
                    self.arrayCourse.removeAll(where: { $0.name == "ALL COURSE"})
                    if self.arrayCourse.count > 0 {
                        self.arrayCourse[0].isOpen = true
                    }
                    
                    // SO SANH 2 ARRAY
                    self.courseRegisted.forEach { (data) in
                        if let indexObject = self.arrayCourse.firstIndex(where: {$0.name == data.name}) {
                            self.arrayCourse[indexObject].isUnLock = true
                        }
                    }
                    
                    self.collectionView.reloadData()
                    self.showLoadingSuccess(1)
                }
            }
        }
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
        
        if arrayCourse[indexPath.section / 2].video.count > 0 {
            cell0.imgDown.isHidden = false
        } else {
            cell0.imgDown.isHidden = true
        }
        
        let data = arrayCourse[indexPath.section / 2]
        cell1.viewDim.isHidden = data.isUnLock
        cell1.imgLock.isHidden = data.isUnLock
        if !data.isUnLock {
            cell1.isUserInteractionEnabled = false
        } else {
            cell1.isUserInteractionEnabled = true
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section % 2 != 0 {
            let course = arrayCourse[indexPath.section / 2].video[indexPath.row]
            if course.type == "Video" { // VIDEO
                if let videoId = getYoutubeId(youtubeUrl: course.linkVideo) {
                    // play video
                    let playerViewController = AVPlayerViewController()
                    self.present(playerViewController, animated: true, completion: nil)
                    XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
                        if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[VideoQuality.hd720] ?? streamURLs[VideoQuality.medium360] ?? streamURLs[VideoQuality.small240]) {
                            playerViewController?.player = AVPlayer(url: streamURL)
                            playerViewController?.player?.play()
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else { // IMAGE
                let cell = collectionView.cellForItem(at: indexPath) as! VideoCell
                let configuration = ImageViewerConfiguration { config in
                    config.imageView = cell.imgVideo
                }
                present(ImageViewerController(configuration: configuration), animated: true)
            }
        } else { // TAP ON HEADER
            collectionView.performBatchUpdates({
                let course = arrayCourse[indexPath.section / 2]
                course.isOpen = !course.isOpen
            }, completion: nil)
        }
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
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

