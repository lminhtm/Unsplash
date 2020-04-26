//
//  FavoritesViewModel.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation

class FavoritesViewModel {
    
    // MARK: - Properties
    
    private var photosCollection: APICollection<Photo>
    private var progressStatus: ProgressStatus
    var collectionDatasource: DataBinding<(APICollection<Photo>, ProgressStatus)>
    
    // MARK: - Init
    
    init() {
        photosCollection = APICollection()
        progressStatus = ProgressStatus()
        collectionDatasource = DataBinding((photosCollection, progressStatus))
        
        // Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidChangeFavorites(_:)),
                                               name: .didChangeFavorites,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Events
    
    @objc func onDidChangeFavorites(_ notification: Notification) {
        loadFavoritePhotos()
    }
    
    // MARK: - Load Data
    
    func loadFavoritePhotos() {
        let photos = FavoriteManager.shared.getFavorites()
        photosCollection.updateItems(with: photos)
        progressStatus.state = photos.isEmpty ? .successWithNoData : .success
        
        // Binding
        collectionDatasource.value = (photosCollection, progressStatus)
    }
    
    func isFavorite(_ photo: Photo) -> Bool {
        return FavoriteManager.shared.isFavorite(photo)
    }
    
    func toggleFavorite(_ photo: Photo) {
        if isFavorite(photo) {
            removeFavorite(photo)
        }
        else {
            addFavorite(photo)
        }
    }
    
    private func addFavorite(_ photo: Photo) {
        FavoriteManager.shared.addFavorite(photo)
    }
    
    private func removeFavorite(_ photo: Photo) {
        FavoriteManager.shared.removeFavorite(photo)
    }
}
