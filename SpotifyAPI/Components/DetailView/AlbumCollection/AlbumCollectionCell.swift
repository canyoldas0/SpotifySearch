//
//  AlbumCollectionCell.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import UIKit

struct AlbumCollectionCellData: DataProtocol {
    let imageUrl: String?
}

final class AlbumCollectionCell: UICollectionViewCell {
    
    private var data: AlbumCollectionCellData?
    
    private lazy var imageContainer: CustomImageViewContainer = {
        let temp = CustomImageViewContainer()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.clipsToBounds = true
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageContainer)
        
        NSLayoutConstraint.activate([
        
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageContainer.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    func setData(with data: DataProtocol?) {
        guard let data = data as? AlbumCollectionCellData,
        let url = data.imageUrl else {
            return
        }
        imageContainer.setData(data: CustomImageViewComponentData(imageUrl: url))
    }
}
