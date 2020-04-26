//
//  ProgressStatusCell.swift
//  Unsplash
//
//  Created by LMinh on 4/25/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit

class ProgressStatusCell: UICollectionViewCell {

    // MARK: - Properties
    
    private var progressStatus: ProgressStatus = ProgressStatus()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.indicatorView.stopAnimating()
        self.retryButton.isHidden = true
        self.retryButton.clipsToBounds = true
        self.retryButton.layer.cornerRadius = 5
    }
    
    // MARK: - UI Stuff
    
    func configure(with progressStatus: ProgressStatus) {
        self.progressStatus = progressStatus
        
        self.statusLabel.text = self.progressStatus.message
        switch self.progressStatus.state {
        case .loading:
            self.indicatorView.startAnimating()
            self.retryButton.isHidden = true
        case .success:
            self.indicatorView.stopAnimating()
            self.retryButton.isHidden = true
        case .successWithNoData:
            self.indicatorView.stopAnimating()
            self.retryButton.isHidden = true
        case .failure(_):
            self.indicatorView.stopAnimating()
            self.retryButton.isHidden = false
        case .unknowned:
            self.indicatorView.stopAnimating()
            self.retryButton.isHidden = true
        }
    }

    // MARK: - Events
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        
    }
}

// MARK: - Utils

extension ProgressStatusCell {
    static var cellId: String {
        return "progressStatusCell"
    }
    
    static var cellNib: UINib {
        return UINib(nibName: "ProgressStatusCell", bundle: nil)
    }
}
