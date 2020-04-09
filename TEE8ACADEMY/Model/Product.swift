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
