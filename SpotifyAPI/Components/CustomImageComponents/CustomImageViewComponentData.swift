//
//  CustomImageViewComponentData.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

class CustomImageViewComponentData: GenericDataProtocol {
    
    private(set) var imageUrl: String
    private(set) var contentMode: UIView.ContentMode = .scaleAspectFill
    private(set) var loadingType: CustomImageLoadingType = .memory
    private(set) var imageId: String?
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
