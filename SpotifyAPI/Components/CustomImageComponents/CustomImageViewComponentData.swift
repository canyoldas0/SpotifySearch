//
//  CustomImageViewComponentData.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

class CustomImageViewComponentData: DataProtocol {
    
    private(set) var imageUrl: String
    private(set) var contentMode: UIView.ContentMode = .scaleAspectFill
    private(set) var loadingType: CustomImageLoadingType = .memory
    private(set) var imageId: String?
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    func setContentMode(by value: UIView.ContentMode) -> Self {
        self.contentMode = value
        return self
    }
    
    func setLoadingType(by value: CustomImageLoadingType) -> Self {
        self.loadingType = value
        return self
    }
    
    func setImageId(by value: String) -> Self {
        self.imageId = value
        return self
    }
}
