//
//  PhotoDetailsViewController.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation
import UIKit

class PhotoDetailsViewController: UIViewController {
    
    public var presenter: PhotoDetailsPresenter?
    private var viewModel: PhotoDetailsViewModel?
    
    @IBOutlet weak var backButton: UIButton!
    
    init(presenter: PhotoDetailsPresenter?) {
        super.init(nibName: "PhotoDetailsViewController", bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Button actions members
    
    @IBAction func performBackButton(_ sender: UIButton) {
        self.presenter?.goBack()
    }
}
