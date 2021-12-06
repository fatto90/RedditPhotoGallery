//
//  PhotoGalleryCollectionViewCell.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation
import UIKit

class PhotoGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var notFoundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highlightedView: UIView!
    
    public static let identifier = "PhotoGalleryCollectionViewCell"
    public var presenter: PhotoGalleryPresenter?
    
    private var viewModel: PhotoImageViewModel?
    
    //MARK: public members
    
    public func renderViewModel(viewModel: PhotoImageViewModel?) {
        self.viewModel = viewModel
        // show that the image is loading
        self.titleLabel.text = self.viewModel?.title
        self.shouldShowNotFound(show: false)
        // remove old image if present
        self.imageView.image = nil
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        // fetch image data
        self.presenter?.getPhotoImage(url: self.viewModel?.thumbnailUrl, completion: {[weak self] data, url in
            
            // This check is useful to avoid concurrency data overrides in cases where the Cell has been reused
            if self?.viewModel?.thumbnailUrl == url {
                // hide the loading view and handle received data
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                if let strongData = data {
                    self?.imageView.image = UIImage(data: strongData)
                } else {
                    self?.shouldShowNotFound(show: true)
                }
            }
        })
        
    }

    //MARK: private members
    
    private func shouldShowNotFound(show: Bool) {
        self.titleView.isHidden = !show
        self.titleLabel.isHidden = !show
        self.notFoundImageView.isHidden = !show
    }
    
}
