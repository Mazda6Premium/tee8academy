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
    
    init(email: String, username: String, password: String, confirmPassword: String, address: String, phone: String, realName: String, course: [Course]) {
        self.email = email
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
        self.address = address
        self.phone = phone
        self.realName = realName
        self.course = course
    }
}
