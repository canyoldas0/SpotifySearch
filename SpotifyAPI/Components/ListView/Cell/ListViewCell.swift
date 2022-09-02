//
//  ListViewCell.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class ListViewCell: UITableViewCell {
    
    private lazy var imageContainer: CustomImageViewContainer = {
        let temp = CustomImageViewContainer()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.clipsToBounds = true
        return temp
    }()
    
    private lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.textAlignment = .left
        temp.text = "Title "
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = .systemFont(ofSize: 15, weight: .bold)
        temp.numberOfLines = 0
        temp.lineBreakMode = .byWordWrapping
        return temp
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViewComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViewComponents()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    private func addViewComponents() {
        contentView.addSubview(imageContainer)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
        
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imageContainer.heightAnchor.constraint(equalToConstant: 100),
            imageContainer.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        imageContainer.layer.cornerRadius = 50
    }
    
    func setData(with data: DataProtocol) {
        guard let data = data as? ListViewCellData else {
            return
        }
        
        if let imageUrl = data.imageUrl {
            imageContainer.setData(data: CustomImageViewComponentData(imageUrl: imageUrl))
        }
        
        if let title = data.title {
            titleLabel.text = title
        }
    }
}
