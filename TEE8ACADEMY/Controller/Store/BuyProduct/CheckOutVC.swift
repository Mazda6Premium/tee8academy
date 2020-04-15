//
//  CheckOutVC.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/14/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import UIKit
import SDWebImage

protocol CheckOutDelegate {
    func deleteCart()
}

class CheckOutVC: UIViewController {
    
    @IBOutlet weak var btnTrash: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let viewDim = UIView()
    var arrayCart = [Cart]()
    var delegate: PopupCheckOutDelegate?
    var delegateCheckOut : CheckOutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPopup()
    }
    
    func showPopup() {
        let vc = PopupCheckOutVC(nibName: "PopupCheckOutVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.arrayCart = self.arrayCart
        vc.delegate = self.delegate
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "CheckOutCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "checkOutCell")
    }
    
    @IBAction func tapOnTrash(_ sender: Any) {
        arrayCart.removeAll()
        tableView.reloadData()
        delegateCheckOut?.deleteCart()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnCart(_ sender: Any) {
        showPopup()
    }
}

extension CheckOutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkOutCell") as! CheckOutCell
        let cart = arrayCart[indexPath.row]
        cell.lblName.text = cart.name
        cell.lblPrice.text = "Giá tiền: \(formatMoney(cart.price)) VND"
        cell.lblNumber.text = "\(cart.quantity)"
        
        cell.backgroundColor = .clear
        cell.btnTru.tag = indexPath.row
        cell.btnCong.tag = indexPath.row
        
        cell.decrease = { index in
            cart.quantity -= 1
            cell.lblNumber.text = "\(cart.quantity)"
            
            if cart.quantity == 0 {
                self.arrayCart.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .fade)
            }
        }
        
        cell.increase = { index in
            cart.quantity += 1
            cell.lblNumber.text = "\(cart.quantity)"
        }
        
        if let url = URL(string: cart.imageUrl) {
            cell.imgProduct.sd_setImage(with: url, completed: nil)
        } else {
            cell.imgProduct.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

}
