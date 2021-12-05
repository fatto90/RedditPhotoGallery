//
//  Container.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import Foundation
import UIKit

class Container {

    // MARK: Properties
    
    static let shared = Container()

    let navigationController: UINavigationController

    private init() {
        self.navigationController = UINavigationController.init(rootViewController: ModuleComposer.shared.photoGallery)
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.isNavigationBarHidden = true
    }
}
