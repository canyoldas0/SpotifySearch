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
        let margins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 10
    }
    
    private func addViewComponents() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.addSubview(imageContainer)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
        
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageContainer.heightAnchor.constraint(equalToConstant: 64),
            imageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 64),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        imageContainer.layer.cornerRadius = 32
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
