//
//  CustomImageViewContainer.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

class CustomImageViewContainer: BaseView<CustomImageViewComponentData> {
    
    private lazy var customImageView: CustomImageViewComponent = {
        let temp = CustomImageViewComponent()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.clipsToBounds = true
        temp.image = UIImage(named: "placeholder")
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    override func setupViews() {
        super.setupViews()
        addCustomImageView()
    }
    
    private func addCustomImageView() {
        addSubview(customImageView)
        
        NSLayoutConstraint.activate([
            
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customImageView.topAnchor.constraint(equalTo: topAnchor),
            customImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func loadDataToView() {
        super.loadDataToView()
        guard let data = returnData() else { return }
        DispatchQueue.main.async {
            self.customImageView.setData(componentData: data)
            self.customImageView.contentMode = data.contentMode
        }
    }
}
