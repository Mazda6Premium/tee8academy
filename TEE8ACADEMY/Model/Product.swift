//
//  Product.swift
//  TEE8ACADEMY
//
//  Created by Linh Nguyen on 4/9/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import Foundation

class Product {
    var id = ""
    var type = ""
    var name = ""
    var description = ""
    var price = 0.0
    var time = 0.0
    var imageUrl = ""
    
    init() {}
    
    init(fromDict: [String: Any]) {
        self.id = fromDict["id"] as? String ?? ""
        self.type = fromDict["type"] as? String ?? ""
        self.name = fromDict["name"] as? String ?? ""
        self.description = fromDict["description"] as? String ?? ""
        self.price = fromDict["price"] as? Double ?? 0.0
        self.time = fromDict["time"] as? Double ?? 0.0
        self.imageUrl = fromDict["imageUrl"] as? String ?? ""
    }
}

class Cart {
    var id = ""
    var name = ""
    var imageUrl = ""
    var description = ""
    var price = 0.0
    var totalPrice = 0.0
    var quantity = 0
    
    init() {}
    
    init(id: String, name: String, description: String, price: Double, totalPrice: Double, quantity: Int, imageUrl: String) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.totalPrice = totalPrice
        self.quantity = quantity
        self.imageUrl = imageUrl
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "price": self.price,
            "totalPrice": self.totalPrice,
            "quantity": self.quantity,
            "imageUrl": self.imageUrl
        ]
    }
}

class Order {
    var userId = ""
    var cart = [Cart]()
    
    init(userId: String, cart: [Cart]) {
        self.userId = userId
        self.cart = cart
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "userId": self.userId,
            "cart": self.cart.map({$0.asDictionary()})
        ]
    }
}
