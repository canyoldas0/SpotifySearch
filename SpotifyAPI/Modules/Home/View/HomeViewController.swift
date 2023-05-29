//
//  HomeViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class HomeViewController: BaseViewController, ErrorHandlingProtocol {
    
    private enum Constants {
        static let searchPlaceholder: String = "Search for the artists"
        static let moreButtonImage: String = "ellipsis"
        static let profileButtonImage: String = "person.circle.fill"
    }
    
    private var viewModel: HomeViewModelProtocol!
    
    private lazy var searchController: UISearchController = {
        let temp = UISearchController()
        temp.searchBar.placeholder = Constants.searchPlaceholder
        temp.searchBar.delegate = self
        return temp
    }()
    
    private lazy var profileButton: UIBarButtonItem = {
        let temp = UIBarButtonItem()
        temp.target = self
        temp.title = "Login"
        temp.action = #selector(profileClicked)
        return temp
    }()
    
    private lazy var moreMenuButton: UIBarButtonItem = {
        let temp = UIBarButtonItem()
        temp.target = self
        temp.image = UIImage(systemName: Constants.moreButtonImage)
        temp.action = #selector(moreMenuClicked)
        return temp
    }()
    
    private var listView: ListView!
    
    convenience init(viewModel: HomeViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    override func setup() {
        super.setup()
        
        prepareUI()
        viewModel.load()
        self.navigationItem.rightBarButtonItem = self.moreMenuButton
    }
    
    override func updateLoader(_ isLoading: Bool) {
        listView.isHidden = isLoading
        super.updateLoader(isLoading)
    }
    
    private func prepareUI() {
        view.backgroundColor = .backgroundColor
        setSearchBar()
        setProfileButton()
        configureListView()
    }
    
    private func setSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = true
        navigationController!.navigationBar.sizeToFit()
        navigationItem.searchController = searchController
    }
    
    private func configureListView() {
        listView = ListView()
        listView.translatesAutoresizingMaskIntoConstraints = false
        listView.delegate = (viewModel as? HomeViewModel)
        
        view.addSubview(listView)
        
        NSLayoutConstraint.activate([
            
            listView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            listView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setProfileButton() {
        self.navigationItem.leftBarButtonItem = self.profileButton
    }
    
    @objc private func profileClicked() {
        viewModel.profileClicked()
    }
    
    @objc private func moreMenuClicked() {
        viewModel.moreMenuClicked()
    }
    
    private func updateProfileIcon(for state: Bool) {
        DispatchQueue.main.async {
            self.profileButton.image = state ? UIImage(systemName: Constants.profileButtonImage): nil
        }
    }
    
    @objc private func reload(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.searchTracks(with: text)
        listView.scrollToTop()
    }
}

extension HomeViewController: HomeViewOutputProtocol {
    
    func handleOutput(_ output: HomeViewOutput) {
        switch output {
        case .setLoading(let isLoading):
            updateLoader(isLoading)
        case .showAlert(let alert):
            showAlert(with: alert)
        case .updateTable:
            listView.updateTable()
        case .updateProfileIcon(let signedIn):
            updateProfileIcon(for: signedIn)
        }
    }
}

// MARK: SearchController Extension
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector:
                                                #selector(self.reload(_:)), object: searchController.searchBar)
        perform(#selector(self.reload(_:)), with: searchController.searchBar, afterDelay: 0.75)
    }   
}
