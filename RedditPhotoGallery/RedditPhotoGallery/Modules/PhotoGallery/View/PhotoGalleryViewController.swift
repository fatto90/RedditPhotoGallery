//
//  PhotoGalleryViewController.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import UIKit

class PhotoGalleryViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoGalleryCollectionView: UICollectionView!
    @IBOutlet weak var extraInfoView: UIView!
    @IBOutlet weak var extraInfoImageView: UIImageView!
    @IBOutlet weak var extraInfoLabel: UILabel!
    
    private var presenter: PhotoGalleryPresenter?
    private var viewModel: PhotoGalleryViewModel?
    
    init(presenter: PhotoGalleryPresenter?) {
        super.init(nibName: "PhotoGalleryViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoGalleryCollectionView.register(UINib(nibName: PhotoGalleryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoGalleryCollectionViewCell.identifier)
        self.presenter?.refreshPhotoGallery(query: "")
        // Hide extra info section
        self.setExtraInfo(shouldShow: false)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.photoGalleryCollectionView.reloadData()
    }

    //MARK: Public members
    
    public func renderViewModel(viewModel: PhotoGalleryViewModel) {
        self.viewModel = viewModel
        let showExtraInfo = self.viewModel?.showExtraInfo ?? false
        self.setExtraInfo(shouldShow: showExtraInfo)
        self.extraInfoLabel.text = self.viewModel?.extraInfoText
        self.extraInfoImageView.image = self.viewModel?.extraInfoIcon
        self.photoGalleryCollectionView.reloadData()
    }
    
    //MARK: Private members
    
    private func setExtraInfo(shouldShow: Bool) {
        self.extraInfoView.isHidden = !shouldShow
        self.extraInfoImageView.isHidden = !shouldShow
        self.extraInfoLabel.isHidden = !shouldShow
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    //MARK: SearchBar delegate members
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter?.refreshPhotoGallery(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    //MARK: CollectionView data source members
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCollectionViewCell.identifier, for: indexPath) as! PhotoGalleryCollectionViewCell
        
        let cellViewModel = self.viewModel?.images?[indexPath.row]
        
        cell.presenter = presenter
        cell.renderViewModel(viewModel: cellViewModel)
        
        return cell
    }
    
    //MARK: CollectionView delegate members
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            (cell as! PhotoGalleryCollectionViewCell).highlightedView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            (cell as! PhotoGalleryCollectionViewCell).highlightedView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter?.showPhotoDetails(images: self.viewModel?.images, index: indexPath.row)
    }
    
    //MARK: CollectionView flow layout delegate members
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = self.photoGalleryCollectionView.bounds.size.width / 3
        return CGSize(width: side, height: side)
    }
}

