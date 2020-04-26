//
//  DownloadsViewModel.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation
import Alamofire

class DownloadsViewModel {
    
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
                                               selector: #selector(onDidDownloadPhoto(_:)),
                                               name: .didDownloadPhoto,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidChangeDownloadingPhotoProgress(_:)),
                                               name: .didChangeDownloadingPhotoProgress,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Events
    
    @objc func onDidDownloadPhoto(_ notification: Notification) {
        loadDownloadPhotos()
    }
    
    @objc func onDidChangeDownloadingPhotoProgress(_ notification: Notification) {
        loadDownloadPhotos()
    }
    
    // MARK: - Load Data
    
    func loadDownloadPhotos() {
        let downloadedPhotos = DownloadManager.shared.getDownloadedPhotos()
        let inprogressPhotos = DownloadManager.shared.getInprogressPhotos()
        let photos: [Photo] = inprogressPhotos + downloadedPhotos
        photosCollection.updateItems(with: photos)
        progressStatus.state = photos.isEmpty ? .successWithNoData : .success
        
        // Binding
        DispatchQueue.main.async {
            self.collectionDatasource.value = (self.photosCollection, self.progressStatus)
        }
    }
    
    func isDownloaded(_ photo: Photo) -> Bool {
        return DownloadManager.shared.isDownloaded(photo)
    }
    
    func downloadingProgress(_ photo: Photo) -> Double? {
        return DownloadManager.shared.downloadingProgress(photo)
    }
}
