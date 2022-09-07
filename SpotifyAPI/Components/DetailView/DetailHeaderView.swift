//
//  DetailView.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import UIKit

struct DetailHeaderData: DataProtocol, Equatable {
    
    
    let imageUrl: String?
    let genreTexts: String?
}

final class DetailHeaderView: BaseView<DetailHeaderData> {
    
    private lazy var imageContainer: CustomImageViewContainer = {
        let temp = CustomImageViewContainer()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.clipsToBounds = true
        return temp
    }()
    
    private lazy var genresLabel: UILabel = {
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
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageContainer)
        addSubview(genresLabel)
        
        NSLayoutConstraint.activate([
        
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: 180),
            imageContainer.widthAnchor.constraint(equalToConstant: 180),
            imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            genresLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 12),
            genresLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            genresLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.roundCorner(with: 16)
    }
    
    override func setData(data: DetailHeaderData?) {
        guard let data = data else {
            return
        }
        
        if let imageUrl = data.imageUrl {
            imageContainer.setData(data: CustomImageViewComponentData(imageUrl: imageUrl))
        }
        
        if let genres = data.genreTexts {
            genresLabel.text = genres
        }
    }
}
