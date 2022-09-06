//
//  UIViewExtensions.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import UIKit

extension UIView {
    
    var height: CGFloat {
            get { return frame.size.height }
            set { frame.size.height = newValue }
        }
    
    var width: CGFloat {
            get { return frame.size.width }
            set { frame.size.width = newValue }
        }
    
    func roundCorner(with radius: CGFloat? = nil) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius ?? (min(self.width,self.height) / 2)
    }
}
