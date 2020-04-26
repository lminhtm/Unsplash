//
//  FavoritesViewController.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: FavoritesViewModel!
    
    @IBOutlet weak var collectionView: PhotoCollectionView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Stuff
        setupUI()
        updateUI()
        
        // Load data
        viewModel.loadFavoritePhotos()
    }

    // MARK: - UI Stuff
    
    func setupUI() {
        // Navigation Bar
        navigationController?.navigationBar.isHidden = true
        
        // Collection View
        collectionView.shouldShowFavoriteButton = true
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
    }
}

// MARK: - Photo Collection View

extension FavoritesViewController: PhotoCollectionViewDelegate {
    
    func photoCollectionViewDidTapFavorite(_ photo: Photo) {
        viewModel.toggleFavorite(photo)
    }
    
    func photoCollectionViewCheckFavoriteForPhoto(_ photo: Photo) -> Bool {
        return viewModel.isFavorite(photo)
    }
    
    func photoCollectionViewDidSelectPhoto(_ photo: Photo, cell: PhotoCell, indexPath: IndexPath) {
        let viewController = PhotoViewController.instanceFromStoryboard
        viewController.viewModel = PhotoViewModel(photo: photo)
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: Utils

extension FavoritesViewController {
    static var instanceFromStoryboard: FavoritesViewController {
        UIStoryboard.main.instantiateViewController(identifier: "favoritesViewController") as! FavoritesViewController
    }
}
