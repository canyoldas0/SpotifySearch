//
//  HomeViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class HomeViewController: UIViewController, ErrorHandlingProtocol {
    
    
    var viewModel: HomeViewModelProtocol!
    
    private lazy var searchController: UISearchController = {
        let temp = UISearchController()
        temp.searchBar.placeholder = "Search for the artists"
        temp.searchBar.delegate = self
        return temp
    }()
    
    convenience init(viewModel: HomeViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        prepareUI()
    }
    
    private func prepareUI() {
        view.backgroundColor = .backgroundColor
        setSearchBar()
    }
    
    private func setSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = true
        navigationController!.navigationBar.sizeToFit()
        navigationItem.searchController = searchController
    }
}

extension HomeViewController: HomeViewOutputProtocol {
    
    func handleOutput(_ output: HomeViewOutput) {
        
    }
}

// MARK: SearchController Extension
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count >= 3 {
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector:
//            #selector(self.reload(_:)), object: searchController.searchBar)
//                perform(#selector(self.reload(_:)), with: searchController.searchBar, afterDelay: 0.75)
//        }
    }
}
