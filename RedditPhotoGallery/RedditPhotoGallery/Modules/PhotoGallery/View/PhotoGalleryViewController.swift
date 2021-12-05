//
//  PhotoGalleryViewController.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import UIKit

class PhotoGalleryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var presenter : PhotoGalleryPresenter?
    
    init(presenter: PhotoGalleryPresenter?) {
        super.init(nibName: "PhotoGalleryViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = "Photo Gallery"
    }


}

