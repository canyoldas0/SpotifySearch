//
//  HomeViewModel.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewOutputProtocol?
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    private let dataHandler: HomeViewDataHandlerProtocol
    
    init(dataHandler: HomeViewDataHandlerProtocol) {
        self.dataHandler = dataHandler
    }
    
    func load() {
        coordinatorDelegate?.goToLogin()
//        callListService()
        delegate?.handleOutput(.updateTable)
    }
    
    func profileClicked() {
        coordinatorDelegate?.goToProfile()
    }
}

extension HomeViewModel: ItemProviderProtocol {
    
    func getNumberOfItems(in section: Int) -> Int {
        return 3
    }
    
    func itemSelected(at index: Int) {
        coordinatorDelegate?.goToDetail(with: "3")
    }
    
    func askData(for index: Int) -> DataProtocol? {
        ListViewCellData(imageUrl: "https://picsum.photos/200", title: "Hello")
    }
}
