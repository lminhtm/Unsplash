//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    // MARK: - Properties
    
    private var photosCollection: APICollection<Photo>
    private var progressStatus: ProgressStatus
    var collectionDatasource: DataBinding<(APICollection<Photo>, ProgressStatus)>
    
    // MARK: - Init
    
    init() {
        photosCollection = APICollection()
        progressStatus = ProgressStatus()
        collectionDatasource = DataBinding((photosCollection, progressStatus))
    }
    
    // MARK: - Load Data
    
    func loadPhotos() {
        progressStatus.state = .loading
        collectionDatasource.value = (photosCollection, progressStatus)
        
        let page = self.photosCollection.items.count/NetworkManager.photosPerPage + 1
        NetworkManager.shared.getPhotos(page: page) { [weak self] (response) in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let collection):
                self.photosCollection.update(with: collection)
                self.progressStatus.state = self.photosCollection.isEmpty ? .successWithNoData : .success
            case .failure(let error):
                self.progressStatus.state = .failure(error)
            }
            
            DispatchQueue.main.async {
                self.collectionDatasource.value = (self.photosCollection, self.progressStatus)
            }
        }
    }
    
    func refreshPhotos() {
        photosCollection.clear()
        loadPhotos()
    }
    
    func loadMorePhotos() {
        guard photosCollection.hasMoreItems() else { return }
        guard case .success = progressStatus.state else { return }
        loadPhotos()
    }
}
