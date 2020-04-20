//
//  Video.swift
//  TEE8ACADEMY
//
//  Created by Trung iOS on 4/9/20.
//  Copyright © 2020 Fighting. All rights reserved.
//

import Foundation

class Video {
    var name = ""
    var course = ""
    var description = ""
    var id = ""
    var linkVideo = ""
    var time = 0.0
    var type = ""
    var imageUrl = ""
    var index = 0
    
    init() {}
    
    init(name: String, course: String, description: String, id: String, linkVideo: String, time: Double, type: String, imageUrl: String, index: Int) {
        self.name = name
        self.course = course
        self.description = description
        self.id = id
        self.linkVideo = linkVideo
        self.time = time
        self.type = type
        self.imageUrl = imageUrl
        self.index = index
    }
    
    static func getVideoData(dict : [String : Any], key: String = "") -> Video {
        let video = Video()
        video.name = dict["name"] as? String ?? ""
        video.course = dict["course"] as? String ?? ""
        video.description = dict["decription"] as? String ?? ""
        video.id = dict["id"] as? String ?? ""
        video.linkVideo = dict["linkVideo"] as? String ?? ""
        video.time = dict["time"] as? Double ?? 0.0
        video.type = dict["type"] as? String ?? ""
        video.imageUrl = dict["imageUrl"] as? String ?? ""
        video.index = dict["index"] as? Int ?? 0
        return video
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "type": self.type,
            "course" : self.course,
            "id" : self.id,
            "name": self.name,
            "description": self.description,
            "linkVideo" : self.linkVideo,
            "time" : self.time,
            "imageUrl": self.imageUrl,
            "index": self.index
        ]
    }
    
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.course = dict["course"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.id = dict["id"] as? String ?? ""
        self.linkVideo = dict["linkVideo"] as? String ?? ""
        self.time = dict["time"] as? Double ?? 0.0
        self.type = dict["type"] as? String ?? ""
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        self.index = dict["index"] as? Int ?? 0
    }
}


