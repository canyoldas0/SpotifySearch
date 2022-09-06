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
    
    private lazy var profileButton: UIBarButtonItem = {
       let temp = UIBarButtonItem()
        temp.target = self
        temp.title = "Login"
        temp.action = #selector(profileClicked)
        return temp
    }()
    
    private var listView: ListView!
    
    convenience init(viewModel: HomeViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        viewModel.load()
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
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem = self.profileButton
        }
    }
    
    @objc private func profileClicked() {
        viewModel.profileClicked()
    }
    
    private func updateProfileIcon(for state: Bool) {
        DispatchQueue.main.async {
            self.profileButton.image = state ? UIImage(systemName: "person.circle.fill"): nil
//            self.profileButton.customView = view
//            self.profileButton.target = view
        }
    }
}

extension HomeViewController: HomeViewOutputProtocol {
    
    func handleOutput(_ output: HomeViewOutput) {
        switch output {
        case .showAlert(let alert):
            showAlert(with: alert)
        case .updateTable:
            listView.updateTable()
        case .updateProfileIcon(let signedIn):
            updateProfileIcon(for: signedIn)
        case .setImageUrl(let urlString):
            return
        }

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
