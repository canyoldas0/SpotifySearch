//
//  DetailViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import UIKit

class DetailViewController: UIViewController, ErrorHandlingProtocol {
    
    private var viewModel: DetailViewModelProtocol!
    
    private var albumCollection: AlbumCollectionView!
    
    private let headerView: DetailHeaderView = {
       let temp = DetailHeaderView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    convenience init(viewModel: DetailViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        prepareUI()
        viewModel.load()
    }
    
    private func prepareUI() {
        albumCollection = AlbumCollectionView()
        albumCollection.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        view.addSubview(albumCollection)
        
        NSLayoutConstraint.activate([
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 240),
        
            albumCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumCollection.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            albumCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumCollection.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension DetailViewController: DetailViewOutputProtocol {
    
    func handleOutput(_ output: DetailViewOutput) {
        switch output {
        case .showAlert(let alert):
            showAlert(with: alert)
        case .updateAlbumData(let albumCollectionData):
            albumCollection.setData(data: albumCollectionData)
        case .updateTitle(let title):
            self.title = title
        case .updateHeader(let data):
            headerView.setData(data: data)
        }
    }
}
