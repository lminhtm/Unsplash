//
//  PhotoViewModel.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation

class PhotoViewModel {
    
    // MARK: - Properties
    
    let photo: Photo
    let isFavorited: DataBinding<Bool>
    let isDownloaded: DataBinding<Bool>
    
    // MARK: - Init
    
    init(photo: Photo) {
        self.photo = photo
        self.isFavorited = DataBinding(FavoriteManager.shared.isFavorite(photo))
        self.isDownloaded = DataBinding(DownloadManager.shared.isDownloaded(photo))
    }
    
    // MARK: - Process
    
    func toggleFavorite() {
        let manager = FavoriteManager.shared
        let isFavorite = manager.isFavorite(photo)
        if isFavorite {
            manager.removeFavorite(photo)
        }
        else {
            manager.addFavorite(photo)
        }
        self.isFavorited.value = !isFavorite
    }
    
    func isDownloadInProgress() -> Bool {
        return DownloadManager.shared.isDownloadInProgress(photo)
    }
    
    func download() {
        let manager = DownloadManager.shared
        if manager.isDownloaded(photo) { return }
        manager.downloadPhoto(photo) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.isDownloaded.value = result
            }
        }
    }
}
