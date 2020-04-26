//
//  PhotoCell.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - PhotoCellDelegate

protocol PhotoCellDelegate: class {
    func photoCellDidTapFavoriteButton(photo: Photo?)
}

class PhotoCell: UICollectionViewCell {

    // MARK: - Properties
    
    private var photo: Photo?
    
    var shouldShowDownloadProgress: Bool = false
    var shouldShowFavoriteButton: Bool = false
    var isFavorited: Bool = false
    var downloaingProgress: Double?
    
    weak var delegate: PhotoCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var downloadProgressView: UIView!
    @IBOutlet weak var downloadProgressLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        downloadProgressView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    // MARK: - UI Stuff
    
    func configure(with photo: Photo) {
        self.photo = photo
        
        imageView.kf.setImage(with: photo.imageResource?.thumbURL)
        favoriteButton.isHidden = !shouldShowFavoriteButton
        
        let image = UIImage(systemName: isFavorited ? "heart.fill" : "heart")
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorited ? .systemRed : .label
        
        downloadProgressView.isHidden = !shouldShowDownloadProgress || downloaingProgress == nil
        let progress = downloaingProgress ?? 0
        downloadProgressLabel.text = "\(Int(100 * progress))%"
    }

    // MARK: - Events
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        delegate?.photoCellDidTapFavoriteButton(photo: photo)
    }
}

// MARK: - Utils

extension PhotoCell {
    static var cellId: String {
        return "photoCell"
    }
    
    static var cellNib: UINib {
        return UINib(nibName: "PhotoCell", bundle: nil)
    }
}
