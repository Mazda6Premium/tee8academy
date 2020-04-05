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
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "name": self.name,
            "price": self.price
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
    
    init(email: String, username: String, password: String, confirmPassword: String, address: String, phone: String, realName: String, course: [Course], paymentMethod: String, imagePayment: String, phoneId: String, phoneModel: String) {
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
            "phoneModel": self.phoneModel
        ]
    }
}
