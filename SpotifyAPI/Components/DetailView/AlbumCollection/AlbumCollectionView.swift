//
//  AlbumCollectionView.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import UIKit

struct AlbumCollectionData: DataProtocol, Equatable {
    
    static func == (lhs: AlbumCollectionData, rhs: AlbumCollectionData) -> Bool {
        lhs.title == rhs.title
    }
    
    let title: String?
    let albumUrls: [AlbumCollectionCellData]
}

final class AlbumCollectionView: BaseView<AlbumCollectionData> {
    
    private lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = .systemFont(ofSize: 24, weight: .black)
        temp.textColor = .black
        temp.text = ""
        return temp
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 130, height: 130)
        layout.minimumInteritemSpacing = 5
        let temp = UICollectionView(frame: .zero, collectionViewLayout: layout)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = .clear
        temp.delegate = self
        temp.dataSource = self
        temp.showsHorizontalScrollIndicator = false
        temp.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.identifier)
        return temp
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
        
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
//            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    override func loadDataToView() {
        super.loadDataToView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.titleLabel.text = self.returnData()?.title
        }
    }
}

// MARK: CollectionView Delegates

extension AlbumCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = returnData() else {
            return 0
        }
        return data.albumUrls.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionCell.identifier, for: indexPath) as? AlbumCollectionCell,
              let data = returnData() else {
            return UICollectionViewCell()
        }
        
        cell.setData(with: data.albumUrls[indexPath.row])
        return cell
    }
}
