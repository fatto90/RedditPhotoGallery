//
//  PhotoDetailsViewController.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation
import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var photoDetailsScrollContentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoDetailsScrollView: UIScrollView!
    @IBOutlet weak var photoDetailsScrollContentView: UIView!
    
    public var presenter: PhotoDetailsPresenter?
    
    private var viewModel: PhotoDetailsViewModel?
    private var photoDetailsViews: [PhotoDetailsView]?
    
    init(presenter: PhotoDetailsPresenter?) {
        super.init(nibName: "PhotoDetailsViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.refreshPhotoDetails()
    }
    
    //MARK: Public members
    
    public func renderViewModel(viewModel: PhotoDetailsViewModel) {
        self.viewModel = viewModel
        self.setupScrollView()
    }
    
    //MARK: Private members
    
    private func setupScrollView() {
        // remove old image details from screen
        for photoDetailsView in self.photoDetailsViews ?? [] {
            photoDetailsView.removeFromSuperview()
        }
        
        var index = 0
        self.photoDetailsViews = []
        
        // force the scroll content view to rerender in order to position subviews correctly
        self.photoDetailsScrollContentView.layoutIfNeeded()
        
        // we need to draw new image details
        for imageViewModel in self.viewModel?.images ?? [] {
            // get a new image details view
            let photoDetailsView = UINib(nibName: "PhotoDetailsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PhotoDetailsView
            // provide position and frame to it
            let position = CGFloat(index) * UIScreen.main.bounds.width
            photoDetailsView.frame = CGRect(x: position, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            self.photoDetailsScrollContentView?.addSubview(photoDetailsView)
            
            // tell her what to render
            photoDetailsView.renderViewModel(viewModel: imageViewModel)
            
            self.photoDetailsViews?.append(photoDetailsView)
            index += 1
        }
        // evaluate the new scroll content view width based on number of images
        self.photoDetailsScrollContentViewWidthConstraint.constant = CGFloat(index) * UIScreen.main.bounds.width
        // show the image selected by user as first
        if let strongStartIndex = self.viewModel?.startIndex {
            self.photoDetailsScrollView.setContentOffset(CGPoint(x: CGFloat(strongStartIndex) * UIScreen.main.bounds.width, y: 0), animated: false)
        }
    }
    
    //MARK: Button actions members
    
    @IBAction func performBackButton(_ sender: UIButton) {
        self.presenter?.goBack()
    }
}
