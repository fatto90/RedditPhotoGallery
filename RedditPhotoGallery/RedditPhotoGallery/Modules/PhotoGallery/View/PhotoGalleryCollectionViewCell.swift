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
    
    public static let identifier = "PhotoGalleryCollectionViewCell"
    public var presenter: PhotoGalleryPresenter?
    
    private var viewModel: PhotoImageViewModel?
    
    //MARK: public members
    
    public func renderViewModel(viewModel: PhotoImageViewModel?) {
        self.viewModel = viewModel
        
        
    }
    
}
