//
//  SessionData.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/8/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import Foundation

class SessionData {
    
    static let shared = SessionData()
    var userData: User?
    var cart: [Cart]?
}
