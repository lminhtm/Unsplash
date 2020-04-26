//
//  HomeViewController.swift
//  Unsplash
//
//  Created by LMinh on 4/22/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var collectionView: PhotoCollectionView!
    var refreshControl: UIRefreshControl!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Stuff
        setupUI()
        updateUI()
        
        // Reload photos
        viewModel.loadPhotos()
    }

    // MARK: - UI Stuff
    
    func setupUI() {
        // Navigation Bar
        navigationController?.navigationBar.isHidden = true
        
        // Collection View
        collectionView.photoDelegate = self
        
        // Pull to refresh
        refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        collectionView.backgroundView = refreshControl
    }
    
    func updateUI() {
        viewModel.collectionDatasource.bind { [weak self] (photosCollection, progressStatus) in
            DispatchQueue.main.async {
                self?.collectionView.progressStatus = progressStatus
                self?.collectionView.photosCollection = photosCollection
                self?.collectionView.reloadData()
                if !progressStatus.isLoading {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Events
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        let viewController = CollectionViewController.instanceFromStoryboard
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func refreshControlValueChanged(_ sender: Any) {
        viewModel.refreshPhotos()
    }
}

// MARK: - Photo Collection View

extension HomeViewController: PhotoCollectionViewDelegate {
    
    func photoCollectionViewDidSelectPhoto(_ photo: Photo, cell: PhotoCell, indexPath: IndexPath) {
        let viewController = PhotoViewController.instanceFromStoryboard
        viewController.viewModel = PhotoViewModel(photo: photo)
        present(viewController, animated: true, completion: nil)
    }
    
    func photoCollectionViewNeedLoadMore() {
        viewModel.loadMorePhotos()
    }
}
