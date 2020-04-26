//
//  PhotoCollectionView.swift
//  Unsplash
//
//  Created by LMinh on 4/25/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

// MARK: - PhotoCollectionViewDelegate

protocol PhotoCollectionViewDelegate: class {
    func photoCollectionViewDidSelectPhoto(_ photo: Photo, cell: PhotoCell, indexPath: IndexPath)
    func photoCollectionViewNeedLoadMore()
    func photoCollectionViewDidTapFavorite(_ photo: Photo)
    func photoCollectionViewCheckFavoriteForPhoto(_ photo: Photo) -> Bool
    func photoCollectionViewDownloadingProgressForPhoto(_ photo: Photo) -> Double?
}

extension PhotoCollectionViewDelegate {
    func photoCollectionViewNeedLoadMore() {}
    func photoCollectionViewDidTapFavorite(_ photo: Photo) {}
    func photoCollectionViewCheckFavoriteForPhoto(_ photo: Photo) -> Bool { return false }
    func photoCollectionViewDownloadingProgressForPhoto(_ photo: Photo) -> Double? { return nil }
}

class PhotoCollectionView: UICollectionView {

    // MARK: - Properties
    
    var photosCollection: APICollection<Photo> = APICollection()
    var progressStatus: ProgressStatus = ProgressStatus()
    var shouldShowFavoriteButton: Bool = false
    var shouldShowDownloadProgress: Bool = false
    
    weak var photoDelegate: PhotoCollectionViewDelegate?
    
    private let itemPerRows: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        // Setup UI
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = sectionInsets
        alwaysBounceVertical = true
        collectionViewLayout = layout
        register(PhotoCell.cellNib, forCellWithReuseIdentifier: PhotoCell.cellId)
        register(ProgressStatusCell.cellNib, forCellWithReuseIdentifier: ProgressStatusCell.cellId)
        dataSource = self
        delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if photosCollection.hasMoreItems() {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && !photosCollection.isEmpty {
            return photosCollection.items.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && !photosCollection.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellId, for: indexPath) as! PhotoCell
            let photo = photosCollection.items[indexPath.row]
            let isFavorited = photoDelegate?.photoCollectionViewCheckFavoriteForPhoto(photo) ?? false
            let downloadingProgress = photoDelegate?.photoCollectionViewDownloadingProgressForPhoto(photo)
            
            cell.shouldShowDownloadProgress = shouldShowDownloadProgress
            cell.shouldShowFavoriteButton = shouldShowFavoriteButton
            cell.isFavorited = isFavorited
            cell.downloaingProgress = downloadingProgress
            cell.delegate = self
            cell.configure(with: photo)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressStatusCell.cellId, for: indexPath) as! ProgressStatusCell
            cell.configure(with: progressStatus)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && !photosCollection.isEmpty {
            let photo = photosCollection.items[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
            photoDelegate?.photoCollectionViewDidSelectPhoto(photo, cell: cell, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is ProgressStatusCell {
            photoDelegate?.photoCollectionViewNeedLoadMore()
        }
    }
}

// MARK: - Waterfall Layout

extension PhotoCollectionView: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 && !photosCollection.isEmpty {
            let availableWidth = frame.width - sectionInsets.left * (itemPerRows + 1)
            let width = availableWidth/itemPerRows
            let photo = photosCollection.items[indexPath.row]
            let height = width/photo.aspectRatio
            return CGSize(width: width, height: height)
        }
        else {
            return CGSize(width: frame.width, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, columnCountForSection section: Int) -> Int {
        if section == 0 && !photosCollection.isEmpty {
            return Int(itemPerRows)
        }
        else {
            return 1
        }
    }
}

// MARK: - PhotoCellDelegate

extension PhotoCollectionView: PhotoCellDelegate {
    func photoCellDidTapFavoriteButton(photo: Photo?) {
        guard let photo = photo else { return }
        photoDelegate?.photoCollectionViewDidTapFavorite(photo)
    }
}
