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
    
    private var presenter: PhotoGalleryPresenter?
    private var viewModel: PhotoGalleryViewModel?
    
    init(presenter: PhotoGalleryPresenter?) {
        super.init(nibName: "PhotoGalleryViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoGalleryCollectionView.register(UINib(nibName: PhotoGalleryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoGalleryCollectionViewCell.identifier)
    }

    //MARK: Public members
    
    public func renderViewModel(viewModel: PhotoGalleryViewModel) {
        self.viewModel = viewModel
        self.photoGalleryCollectionView.reloadData()
    }
    
    public func renderError() {
    }

    //MARK: SearchBar delegate members
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter?.refreshPhotoGallery(query: searchText)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellViewModel = self.viewModel?.images?[indexPath.row]

    }
    
    //MARK: CollectionView flow layout delegate members
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = UIScreen.main.bounds.size.width / 2
        return CGSize(width: side, height: side)
    }
}

