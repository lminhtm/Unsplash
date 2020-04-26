//
//  DownloadManager.swift
//  Unsplash
//
//  Created by LMinh on 4/25/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation
import Alamofire

class DownloadManager {
    
    // MARK: - Properties
    
    private let downloadedPhotosKey = "downloadedPhotosKey"
    private let downloadQueue: DispatchQueue
    private var downloadsInProgress: [Photo: Double]
    private var downloadedPhotos: [Photo] = []
    
    var cacheFolderURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent("Photo")
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch { }
        }
        return url
    }
    
    /// Shared download manager object.
    static let shared = DownloadManager()
    
    // MARK: - Initialization
    
    private init() {
        downloadQueue = DispatchQueue(label: "Download Queue", attributes: .concurrent)
        downloadsInProgress = [:]
        
        // Fetch downloads
        if let data = UserDefaults.standard.object(forKey: downloadedPhotosKey) as? Data {
            let decoder = JSONDecoder()
            if let downloads = try? decoder.decode([Photo].self, from: data) {
                self.downloadedPhotos = downloads
            }
        }
    }
    
    // MARK: - Process
    
    private func addDownload(_ photo: Photo) {
        downloadedPhotos.insert(photo, at: 0)
        updateDownloadedPhotos()
    }
    
    private func cleanupDownloadedPhotos() {
        do {
            try FileManager.default.removeItem(at: cacheFolderURL)
        } catch { }
        
        downloadedPhotos.removeAll()
        updateDownloadedPhotos()
    }
    
    private func updateDownloadedPhotos() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.downloadedPhotos) {
            UserDefaults.standard.set(encoded, forKey: downloadedPhotosKey)
        }
        else {
            UserDefaults.standard.set(nil, forKey: downloadedPhotosKey)
        }
    }
}

// MARK: - Public

extension DownloadManager {
    
    func getDownloadedPhotos() -> [Photo] {
        return downloadedPhotos
    }
    
    func getInprogressPhotos() -> [Photo] {
        return Array(downloadsInProgress.keys)
    }
    
    func isDownloaded(_ photo: Photo) -> Bool {
        return downloadedPhotos.contains(photo)
    }
    
    func downloadedRawImage(_ photo: Photo) -> UIImage? {
        guard let photoId = photo.id else { return nil }
        let path = cacheFolderURL.appendingPathComponent(photoId).path
        let image = UIImage(contentsOfFile: path)
        return image
    }
    
    func isDownloadInProgress(_ photo: Photo) -> Bool {
        return downloadsInProgress.keys.contains(photo)
    }
    
    func downloadingProgress(_ photo: Photo) -> Double? {
        if let progress = downloadsInProgress[photo] {
            return progress
        }
        return nil
    }
    
    func downloadPhoto(_ photo: Photo, completionHandler: @escaping (Bool) -> Void) {
        
        if downloadsInProgress[photo] != nil {
            return
        }
        
        // Update progress
        downloadsInProgress[photo] = 0.0
        
        downloadQueue.async {
            NetworkManager.shared.downloadPhoto(photo, progressHandler: { [weak self] (progress) in
                // Update progress
                self?.downloadsInProgress[photo] = progress.fractionCompleted
                
                // Broadcast
                NotificationCenter.default.post(name: .didChangeDownloadingPhotoProgress, object: photo)
            }) { [weak self] (response) in
                // Update progress
                self?.downloadsInProgress.removeValue(forKey: photo)
                
                switch response.result {
                case .success(_):
                    self?.addDownload(photo)
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)
                }
                
                // Broadcast
                NotificationCenter.default.post(name: .didDownloadPhoto, object: photo)
            }
        }
    }
}

// MARK: - Notification

extension Notification.Name {
    static let didDownloadPhoto = Notification.Name("didDownloadPhoto")
    static let didChangeDownloadingPhotoProgress = Notification.Name("didChangeDownloadingPhotoProgress")
}
