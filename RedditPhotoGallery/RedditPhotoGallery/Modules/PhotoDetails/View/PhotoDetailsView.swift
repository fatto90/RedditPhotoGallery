//
//  PhotoDetailsView.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 06/12/21.
//

import Foundation
import UIKit

class PhotoDetailsView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var viewModel: PhotoImageViewModel?
    public var presenter: PhotoDetailsPresenter?
    
    //MARK: Public members
    
    public func renderViewModel(viewModel: PhotoImageViewModel) {
        self.viewModel = viewModel
        self.imageViewWidthConstraint.constant = UIScreen.main.bounds.width
        self.titleLabel.text = viewModel.title
    }
    
    public func renderImage() {
        // remove old image if present
        self.imageView.image = nil
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        // fetch image data
        self.presenter?.getPhotoImage(url: self.viewModel?.imageUrl, completion: {[weak self] data, url in
            
            // This check is useful to avoid concurrency data overrides in cases where the Cell has been reused
            if self?.viewModel?.imageUrl == url {
                // hide the loading view and handle received data
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                if let strongData = data {
                    self?.imageView.image = UIImage(data: strongData)
                } else {
                    self?.imageView.image = UIImage(systemName: "photo")
                }
            }
        })
    }
}
