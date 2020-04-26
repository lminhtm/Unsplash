//
//  DownloadsViewController.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit

class DownloadsViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: DownloadsViewModel!
    var favoritesViewModel: FavoritesViewModel!
    
    @IBOutlet weak var collectionView: PhotoCollectionView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Stuff
        setupUI()
        updateUI()
        
        // Load data
        viewModel.loadDownloadPhotos()
    }

    // MARK: - UI Stuff
    
    func setupUI() {
        // Navigation Bar
        navigationController?.navigationBar.isHidden = true
        
        // Collection View
        collectionView.shouldShowFavoriteButton = true
        collectionView.shouldShowDownloadProgress = true
        collectionView.photoDelegate = self
    }
    
    func updateUI() {
        viewModel.collectionDatasource.bind { [weak self] (photosCollection, progressStatus) in
            DispatchQueue.main.async {
                self?.collectionView.progressStatus = progressStatus
                self?.collectionView.photosCollection = photosCollection
                self?.collectionView.reloadData()
            }
        }
        
        favoritesViewModel.collectionDatasource.bind {  [weak self] (photosCollection, progressStatus) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Photo Collection View

extension DownloadsViewController: PhotoCollectionViewDelegate {
    
    func photoCollectionViewDidTapFavorite(_ photo: Photo) {
        favoritesViewModel.toggleFavorite(photo)
    }
    
    func photoCollectionViewCheckFavoriteForPhoto(_ photo: Photo) -> Bool {
        return favoritesViewModel.isFavorite(photo)
    }
    
    func photoCollectionViewDownloadingProgressForPhoto(_ photo: Photo) -> Double? {
        return viewModel.downloadingProgress(photo)
    }
    
    func photoCollectionViewDidSelectPhoto(_ photo: Photo, cell: PhotoCell, indexPath: IndexPath) {
        guard viewModel.downloadingProgress(photo) == nil else {
            return
        }
        
        let viewController = PhotoViewController.instanceFromStoryboard
        viewController.viewModel = PhotoViewModel(photo: photo)
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: Utils

extension DownloadsViewController {
    static var instanceFromStoryboard: DownloadsViewController {
        UIStoryboard.main.instantiateViewController(identifier: "downloadsViewController") as! DownloadsViewController
    }
}

