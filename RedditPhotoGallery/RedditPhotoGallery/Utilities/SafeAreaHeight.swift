//
//  SafeAreaHeight.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 06/12/21.
//

import Foundation
import UIKit

class SafeAreaHeight {
    
    static let shared = SafeAreaHeight()
    
    public func getSafeAreaHeight() -> CGFloat {
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            topPadding = window?.safeAreaInsets.top ?? 0
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        return UIScreen.main.bounds.height - (topPadding + bottomPadding)
    }
}
