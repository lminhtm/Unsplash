//
//  NetworkManager+Photo.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

extension NetworkManager {
    
    static let photosPerPage = 10
    
    func getPhotos(page: Int, completionHandler: @escaping (AFDataResponse<APICollection<Photo>>) -> Void) {
        
        let path = "/search/photos"
        let params: JSON = ["page": page, "query": "girls", "per_page": NetworkManager.photosPerPage]
        guard let urlRequest = try? buildURLRequest(path, params: params) else { return }
        
        AF.request(urlRequest, interceptor: self)
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
    
    func downloadPhoto(_ photo: Photo,
                       progressHandler: @escaping (Progress) -> Void,
                       completionHandler: @escaping (AFDownloadResponse<URL?>) -> Void) {
        
        guard let photoId = photo.id else { return }
        guard let url = photo.imageResource?.rawsURL else { return }
        
        let destination: DownloadRequest.Destination = { _, _ in
            var cacheFolderURL = DownloadManager.shared.cacheFolderURL
            cacheFolderURL.appendPathComponent(photoId)
            return (cacheFolderURL, [.removePreviousFile])
        }
        
        AF.download(url, to: destination)
            .downloadProgress(closure: progressHandler)
            .response(completionHandler: completionHandler)
    }
}

