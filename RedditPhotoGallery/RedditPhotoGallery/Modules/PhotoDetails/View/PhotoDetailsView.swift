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
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    public var viewModel: PhotoImageViewModel?
    public var presenter: PhotoDetailsPresenter?
    public var bottomGradientLayer: CAGradientLayer?
    
    //MARK: Public members

    public func renderViewModel(viewModel: PhotoImageViewModel) {
        self.viewModel = viewModel
        // setup the zoom
        self.imageScrollView.minimumZoomScale = 1.0
        self.imageScrollView.maximumZoomScale = 3.0
        self.imageViewWidthConstraint.constant = UIScreen.main.bounds.width
        self.imageViewHeightConstraint.constant = SafeAreaHeight.shared.getSafeAreaHeight()
        
        self.titleLabel.text = viewModel.title
        self.authorLabel.text = viewModel.author != nil ? "Made by \(String(describing: viewModel.author!))" : nil
        self.titleLabel.textColor = UIColor.white
        self.authorLabel.textColor = UIColor.white
        
        // setup and insert the gradient layer to bottom view
        self.bottomGradientLayer?.removeFromSuperlayer()
        self.bottomGradientLayer = CAGradientLayer()
        self.bottomGradientLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
        self.bottomGradientLayer?.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]

        self.bottomGradientView?.layer.insertSublayer(self.bottomGradientLayer!, at: 0)
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
    
    public func setImageScrollViewDelegate(delegate: UIScrollViewDelegate) {
        self.imageScrollView.delegate = delegate
    }
}
