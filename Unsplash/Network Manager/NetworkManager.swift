//
//  NetworkManager.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation
import Alamofire

/// JSON
typealias JSON = [String: Any]

/// The NetworkManager class enables you to perform many network related operations.
final class NetworkManager {
    
    // MARK: - Properties
    
    private let baseURL = "https://api.unsplash.com"
    private let accessKey = "Wv0RsMRZcrJpkkSZF7OgadYOCL8xIm3ueUnSlLAlgVA"
    private let secretKey = "ZbHjTnmatPoCm0n0gGN4XaQNSyurbvPXvvZp0p0O7dQ"
    
    /// Shared network manager object.
    static let shared = NetworkManager()
    
    // MARK: - Initialization
    
    private init() {
    }
}

// MARK: - RequestAdapter

extension NetworkManager: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURL) {
            urlRequest.setValue("Client-ID " + accessKey, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    func buildURLRequest(_ path: String, method: HTTPMethod = .get, params: JSON? = nil)  throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        return urlRequest
    }
}
