//
//  StringExtensions.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import UIKit

extension String {
    
    func size(font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttribute)
    }
}
