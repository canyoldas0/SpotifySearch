//
//  UIControlExtensions.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

extension UIControl {
    
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}
