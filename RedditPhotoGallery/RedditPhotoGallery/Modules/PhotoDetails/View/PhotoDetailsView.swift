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
    
    public var viewModel: PhotoImageViewModel?
    
    //MARK: Public members
    
    public func renderViewModel(viewModel: PhotoImageViewModel) {
        self.viewModel = viewModel
        self.imageViewWidthConstraint.constant = UIScreen.main.bounds.width
        self.titleLabel.text = viewModel.title
    }
}
