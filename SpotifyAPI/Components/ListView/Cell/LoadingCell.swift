//
//  LoadingCell.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 7.09.2022.
//

import UIKit

class LoadingCellView: UITableViewCell {

    var activityIndicator: UIActivityIndicatorView!
    
  
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareViewCell()
    }
    
    private func prepareViewCell() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium

        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        indicator.startAnimating()
    }
}
