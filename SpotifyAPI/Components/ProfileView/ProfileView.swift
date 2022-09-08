//
//  ProfileView.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import UIKit

struct ProfileViewData: GenericDataProtocol, Equatable {
    
    static func == (lhs: ProfileViewData, rhs: ProfileViewData) -> Bool {
        lhs.displayName == rhs.displayName
    }
    
    let displayName: String?
    let imageUrl: String?
    let logoutAction: VoidHandler?
}

final class ProfileView: BaseView<ProfileViewData> {
    
    private lazy var imageContainer: CustomImageViewContainer = {
        let temp = CustomImageViewContainer()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.clipsToBounds = true
        return temp
    }()
    
    private lazy var nameLabel: UILabel = {
        let temp = UILabel()
        temp.textAlignment = .left
        temp.text = "Title "
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = .systemFont(ofSize: 16, weight: .light)
        temp.numberOfLines = 0
        temp.textAlignment = .center
        temp.lineBreakMode = .byWordWrapping
        return temp
    }()
    
    private let logoutButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Logout", for: .normal)
        temp.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        temp.setTitleColor(.red, for: .normal)
        return temp
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageContainer)
        addSubview(nameLabel)
        addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
        
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            imageContainer.widthAnchor.constraint(equalToConstant: 135),
            imageContainer.heightAnchor.constraint(equalToConstant: 135),

            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 16),
            
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    override func setData(data: ProfileViewData?) {
        guard let data else {
            return
        }
        
        if let name = data.displayName {
            nameLabel.text = name
        }
        
        if let imageUrl = data.imageUrl {
            imageContainer.setData(data: CustomImageViewComponentData(imageUrl: imageUrl))
        }
        
        logoutButton.addAction {
            data.logoutAction?()
        }
    }
}
