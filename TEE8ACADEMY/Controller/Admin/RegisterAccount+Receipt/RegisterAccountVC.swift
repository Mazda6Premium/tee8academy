//
//  RegisterAccount+Receipt.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/7/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import FSPagerView
import FirebaseDatabase
import FirebaseStorage

class RegisterAccountVC: BaseViewController {
    
    @IBOutlet weak var pageView: FSPagerView!
    
    var arrayUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPageView()
        getDataFromFirebase()
    }
    
    func getDataFromFirebase() {
        showLoading()
        var haveData = false
        databaseReference.child("Receipt").observe(.childAdded) { (snapshot) in
            haveData = true
            databaseReference.child("Receipt").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String: Any] {
                    let user = User.getUserData(dict: dict, key: snapshot1.key)
                    self.arrayUser.append(user)
                    self.arrayUser.sort(by: { (user1, user2) -> Bool in
                        return Int64(user1.time) > Int64(user2.time)
                    })
                    DispatchQueue.main.async {
                        self.pageView.reloadData()
                    }
                    self.showLoadingSuccess(1)
                }
            }
        }
        
        if !haveData {
            hideLoading()
        }
    }
    
    func setupPageView() {
        pageView.delegate = self
        pageView.dataSource = self
        
        roundCorner(views: [pageView], radius: 10)
        
        let nib = UINib(nibName: "RegisterAccountCell", bundle: nil)
        pageView.register(nib, forCellWithReuseIdentifier: "registerAccountCell")
        pageView.transformer = FSPagerViewTransformer(type: .cubic)
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterAccountVC: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrayUser.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "registerAccountCell", at: index) as! RegisterAccountCell
        cell.user = arrayUser[index]
        cell.parentVC = self
        
        cell.btnActive.addTarget(self, action: #selector(tapOnActive), for: .touchUpInside)
        cell.btnActive.tag = index
        
        cell.btnCancel.addTarget(self, action: #selector(tapOnCancel), for: .touchUpInside)
        cell.btnCancel.tag = index
        
        return cell
    }
    
    @objc func tapOnActive(sender: UIButton) {
        showLoading()
        let user = arrayUser[sender.tag]
        let email = user.email
        let password = user.password
        auth.createUser(withEmail: email, password: password) { (auth, error) in
            if error != nil {
                self.showToast(message: "Có lỗi xảy ra, vui lòng thử lại sau.")
                self.hideLoading()
                return
            }
            
            if let userRegister = auth {
                user.userId = userRegister.user.uid
                print(user.asDictionary())
                databaseReference.child("Users").child(user.userId).setValue(user.asDictionary())
                databaseReference.child("EmailAlreadyUsing").setValue(["\(user.email)": true])
                
                self.deleteImage(index: sender.tag)
                databaseReference.child("Receipt").child(user.postId).removeValue()
                
                self.arrayUser.removeAll()
                self.getDataFromFirebase()
                self.pageView.reloadData()
            }
        }
    }
    
    @objc func tapOnCancel(sender: UIButton) {
        showLoading()
        let user = arrayUser[sender.tag]
        deleteImage(index: sender.tag)
        databaseReference.child("Receipt").child(user.postId).removeValue()
        
        self.arrayUser.removeAll()
        self.getDataFromFirebase()
        self.pageView.reloadData()
    }
    
    func deleteImage(index: Int) {
        let url = arrayUser[index].imagePayment
        let storageRef = Storage.storage().reference(forURL: url)
        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                print(error)
            }
        }
    }
}
