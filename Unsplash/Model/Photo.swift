//
//  Photo.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit
import ObjectMapper

struct Photo: Codable {
    var id: String?
    var width: CGFloat?
    var height: CGFloat?
    var imageResource: ImageResource?
    var user: User?
    
    var aspectRatio: CGFloat {
        guard let width = width, let height = height, height != 0 else { return 1 }
        return width/height
    }
}

// MARK: - Equatable

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        guard let lhsId = lhs.id, let rhsId = rhs.id else {
            return false
        }
        return lhsId == rhsId
    }
}

// MARK: - Hashable

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        guard let id = id else { return }
        hasher.combine(id)
    }
}

// MARK: - Mappable

extension Photo: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        width <- map["width"]
        height <- map["height"]
        imageResource <- map["urls"]
        user <- map["user"]
    }
}
