//
//  User.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Codable {
    var id: String?
    var username: String?
    var name: String?
    var avatar: ImageResource?
}

// MARK: - Mappable

extension User: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        name <- map["name"]
        avatar <- map["profile_image"]
    }
}
