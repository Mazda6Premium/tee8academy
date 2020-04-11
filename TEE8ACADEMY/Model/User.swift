//
//  User.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/4/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import Foundation

class Course {
    var name = ""
    var price = 0.0
    var isSelected = false
    var description = ""
    var time = 0.0
    var video = [Video]()
    var isOpen = false

    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    init(video: [Video]) {
        self.video = video
    }
    
    init(fromDict: [String: Any]) {
        self.name = fromDict["name"] as? String ?? ""
        self.price = fromDict["price"] as? Double ?? 0.0
        self.description = fromDict["description"] as? String ?? ""
        self.time = fromDict["time"] as? Double ?? 0.0
        if let video = fromDict["videos"] as? [[String: Any]] {
            self.video = video.map({Video(dict: $0)})
        }
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "name": self.name,
            "price": self.price
        ]
    }
    
    func asDictionaryVideo() -> [String: Any] {
        return [
            "videos": self.video.map({$0.asDictionary()})
        ]
    }
}

class User {
    var email = ""
    var username = ""
    var password = ""
    var confirmPassword = ""
    var address = ""
    var phone = ""
    var realName = ""
    var course = [Course]()
    var paymentMethod = ""
    var imagePayment = ""
    var phoneId = ""
    var phoneModel = ""
    var time = 0.0
    var totalPayment = 0.0
    var postId = ""
    var userId = ""
    
    init() {}
    
    init(email: String, username: String, password: String, confirmPassword: String, address: String, phone: String, realName: String, course: [Course], paymentMethod: String, imagePayment: String, phoneId: String, phoneModel: String, time: Double, totalPayment: Double, postId: String, userId: String) {
        self.email = email
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
        self.address = address
        self.phone = phone
        self.realName = realName
        self.course = course
        self.phoneId = phoneId
        self.phoneModel = phoneModel
        self.paymentMethod = paymentMethod
        self.imagePayment = imagePayment
        self.time = time
        self.totalPayment = totalPayment
        self.postId = postId
        self.userId = userId
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "email": self.email,
            "username": self.username,
            "password": self.password,
            "address": self.address,
            "phone": self.phone,
            "realName": self.realName,
            "course": self.course.map({$0.asDictionary()}),
            "paymentMethod": self.paymentMethod,
            "imagePayment": self.imagePayment,
            "phoneId": self.phoneId,
            "phoneModel": self.phoneModel,
            "time": self.time,
            "totalPayment": self.totalPayment,
            "postId": self.postId,
            "userId": self.userId
        ]
    }
    
    init(dict: [String: Any]) {
        self.email = dict["email"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.address = dict["address"] as? String ?? ""
        self.phone = dict["phone"] as? String ?? ""
        self.realName = dict["realName"] as? String ?? ""
        self.paymentMethod = dict["paymentMethod"] as? String ?? ""
        self.imagePayment = dict["imagePayment"] as? String ?? ""
        self.time = dict["time"] as? Double ?? 0.0
        self.totalPayment = dict["totalPayment"] as? Double ?? 0.0
        self.postId = dict["postId"] as? String ?? ""
        self.phoneId = dict["phoneId"] as? String ?? ""
        self.phoneModel = dict["phoneModel"] as? String ?? ""
        self.password = dict["password"] as? String ?? ""
        self.userId = dict["userId"] as? String ?? ""
        if let course = dict["course"] as? [[String: Any]] {
            self.course = course.map({Course(fromDict: $0)})
        }
    }
}

extension User {
    static func getUserData(dict : [String : Any], key: String = "") -> User {
        let user = User()
        user.email = dict["email"] as? String ?? ""
        user.username = dict["username"] as? String ?? ""
        user.address = dict["address"] as? String ?? ""
        user.phone = dict["phone"] as? String ?? ""
        user.realName = dict["realName"] as? String ?? ""
        user.paymentMethod = dict["paymentMethod"] as? String ?? ""
        user.imagePayment = dict["imagePayment"] as? String ?? ""
        user.time = dict["time"] as? Double ?? 0.0
        user.totalPayment = dict["totalPayment"] as? Double ?? 0.0
        user.postId = dict["postId"] as? String ?? ""
        user.phoneId = dict["phoneId"] as? String ?? ""
        user.phoneModel = dict["phoneModel"] as? String ?? ""
        user.password = dict["password"] as? String ?? ""
        user.userId = dict["userId"] as? String ?? ""
        if let course = dict["course"] as? [[String: Any]] {
            user.course = course.map({Course(fromDict: $0)})
        }
        
        return user
    }
}
