//
//  ImageResource.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation
import ObjectMapper
import Kingfisher

struct ImageResource: Codable {
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
    var medium: String?
    var thumb: String?
    
    var thumbURL: URL? {
        guard let thumb = thumb else { return nil }
        return URL(string: thumb)
    }
    
    var fullURL: URL? {
        guard let full = full else { return nil }
        return URL(string: full)
    }
    
    var rawsURL: URL? {
        guard let raw = raw else { return nil }
        return URL(string: raw)
    }
    
    var mediumURL: URL? {
        guard let medium = medium else { return nil }
        return URL(string: medium)
    }
    
    var cachedThumbImage: UIImage? {
        var image: UIImage? = nil
        if let thumbURL = thumbURL {
            let resource = Kingfisher.ImageResource(downloadURL: thumbURL)
            KingfisherManager.shared.retrieveImage(with: resource, options: [.onlyFromCache]) { (result) in
                if case .success(let imageResult) = result {
                    image = imageResult.image
                }
            }
        }
        return image
    }
}

// MARK: - Mappable

extension ImageResource: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        raw <- map["raw"]
        full <- map["full"]
        regular <- map["regular"]
        small <- map["small"]
        medium <- map["medium"]
        thumb <- map["thumb"]
    }
}
