//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: PhotoViewModel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI Stuff
        setupUI()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        imageViewHeightConstraint.constant = imageView.frame.width/viewModel.photo.aspectRatio 
    }
    
    // MARK: - UI Stuff
    
    func setupUI() {
        // Navigation Bar
        navigationController?.navigationBar.isHidden = true
        
        // Scroll View
        scrollView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        // User View
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width/2
    }
    
    func updateUI() {
        // Image View
        let photo = viewModel.photo
        imageView.kf.setImage(with: photo.imageResource?.fullURL,
                              placeholder: photo.imageResource?.cachedThumbImage,
                              options: [.transition(.fade(0.5))])
        
        // User View
        nameLabel.text = photo.user?.name
        usernameLabel.text = "@\(photo.user?.username ?? "-")"
        userImageView.kf.setImage(with: photo.user?.avatar?.mediumURL)
        
        // Favorite Button
        viewModel.isFavorited.bindAndFire { [weak self] (isFavorited) in
            let image = UIImage(systemName: isFavorited ? "heart.fill" : "heart")
            self?.favoriteButton.setImage(image, for: .normal)
            self?.favoriteButton.tintColor = isFavorited ? .systemRed : .label
        }
        
        // Download Button
        viewModel.isDownloaded.bindAndFire { [weak self] (isDownloaded) in
            self?.downloadButton.isEnabled = !isDownloaded
        }
    }
    
    // MARK: - Events
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        if viewModel.isDownloadInProgress() {
            let alert = UIAlertController(title: "Download", message: "In progress", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okie", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            viewModel.download()
            
            let alert = UIAlertController(title: "Download", message: "Added to the download queue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okie", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        viewModel.toggleFavorite()
    }
}

// MARK: Utils

extension PhotoViewController {
    static var instanceFromStoryboard: PhotoViewController {
        UIStoryboard.main.instantiateViewController(identifier: "photoViewController") as! PhotoViewController
    }
}
