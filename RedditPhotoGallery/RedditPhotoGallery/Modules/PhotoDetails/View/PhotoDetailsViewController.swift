//
//  PhotoDetailsViewController.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation
import UIKit

class PhotoDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var photoDetailsScrollContentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoDetailsScrollView: UIScrollView!
    @IBOutlet weak var photoDetailsScrollContentView: UIView!
    
    public var presenter: PhotoDetailsPresenter?
    
    private var viewModel: PhotoDetailsViewModel?
    private var photoDetailsViews: [PhotoDetailsView]?
    private var currentPage: Int = 0
    private var lastDeviceOrientation: UIDeviceOrientation?
    
    init(presenter: PhotoDetailsPresenter?) {
        super.init(nibName: "PhotoDetailsViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.refreshPhotoDetails()
    }
    
    @objc func orientationChanged() {
        let newDeviceOrientation = UIDevice.current.orientation
        // refresh only if orientation is really changed
        if ((self.lastDeviceOrientation == nil) ||
            newDeviceOrientation.isLandscape && (self.lastDeviceOrientation?.isPortrait ?? false)) ||
            (newDeviceOrientation.isPortrait && (self.lastDeviceOrientation?.isLandscape ?? false)) {
            self.presenter?.refreshPhotoDetails()
        }
        self.lastDeviceOrientation = newDeviceOrientation
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
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
        let imageViewModels = self.viewModel?.images ?? []
        self.photoDetailsViews = []
        
        let viewWidth = self.photoDetailsScrollView.frame.width
        // evaluate the new scroll content view width based on number of images
        self.photoDetailsScrollContentViewWidthConstraint.constant = CGFloat(imageViewModels.count) * viewWidth
        
        // force the scrollView to rerender in order to position subviews correctly
        self.photoDetailsScrollView.layoutIfNeeded()
        
        // we need to draw new image details
        for imageViewModel in imageViewModels {
            // get a new image details view
            let photoDetailsView = UINib(nibName: "PhotoDetailsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PhotoDetailsView
            
            // provide position and frame to it
            let position = CGFloat(index) * viewWidth
            photoDetailsView.frame = CGRect(x: position, y: 0, width: viewWidth, height: self.photoDetailsScrollView.frame.height)
            photoDetailsView.setContentAspectRatio(width: viewWidth, height: self.photoDetailsScrollView.frame.height)
            self.photoDetailsScrollContentView?.addSubview(photoDetailsView)
            
            // tell her what to render
            photoDetailsView.presenter = self.presenter
            photoDetailsView.setImageScrollViewDelegate(delegate: self)
            photoDetailsView.renderViewModel(viewModel: imageViewModel)
            
            self.photoDetailsViews?.append(photoDetailsView)
            index += 1
        }
        // set the current page from viewModel and load the image, show the image selected by user as first
        self.currentPage = self.viewModel?.startIndex ?? 0
        self.photoDetailsScrollView.setContentOffset(CGPoint(x: CGFloat(self.currentPage) * self.photoDetailsScrollView.bounds.width, y: 0), animated: false)
        self.loadCurrentPageImage()
    }
    
    private func loadCurrentPageImage() {
        self.photoDetailsViews?[self.currentPage].renderImage()
    }
    
    private func stoppedScrolling() {
        let page: Int = Int(self.photoDetailsScrollView.contentOffset.x / self.photoDetailsScrollView.frame.size.width);
        if self.currentPage != page && page >= 0 && page <= (self.photoDetailsViews?.count ?? 0) {
            self.currentPage = page
            self.presenter?.update(startIndex: page)
            self.loadCurrentPageImage()
        }
    }
    
    //MARK: Button actions members
    
    @IBAction func performBackButton(_ sender: UIButton) {
        self.presenter?.goBack()
    }
    
    //MARK: ScrollView delegate member
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.photoDetailsScrollView {
            self.stoppedScrolling()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.photoDetailsScrollView && !decelerate {
            self.stoppedScrolling()
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != self.photoDetailsScrollView {
            return self.photoDetailsViews?[self.currentPage].imageView
        }
        return nil
    }
}
