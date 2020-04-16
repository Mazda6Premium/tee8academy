//
//  UserManagerVC.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/15/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit

class UserManagerVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayUser = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
        getDataFromFirebase()
    }

    func setUpTableView() {
        let userManagerCell_xib = UINib(nibName: "UserManagerCell", bundle: nil)
        tableView.register(userManagerCell_xib, forCellReuseIdentifier: "userManagerCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func getDataFromFirebase() {
        showLoading()
        databaseReference.child("Users").observe(.childAdded) { (snapshot) in
            databaseReference.child("Users").child(snapshot.key).observeSingleEvent(of: .value) { (snapshot1) in
                if let dict = snapshot1.value as? [String:Any] {
                    let user = User(dict: dict)
                    self.arrayUser.append(user)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    self.showLoadingSuccess(1)
                }
            }
        }
    }
    @IBAction func tapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UserManagerVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userManagerCell") as! UserManagerCell
        let user = arrayUser[indexPath.row]
        
        cell.selectionStyle = .none
        cell.viewUser.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
        cell.viewBlock.backgroundColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0.6470588235, alpha: 1)
        cell.lblName.text = user.username
        cell.lblEmail.text = user.email
        cell.viewBlock.tag = indexPath.row
        
        let tapGes1 = UITapGestureRecognizer(target: self, action: #selector(tapOnViewBlock))
        cell.viewBlock.addGestureRecognizer(tapGes1)
        
        return cell
    }
    
    @objc func tapOnViewBlock(_ sender : UITapGestureRecognizer) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
