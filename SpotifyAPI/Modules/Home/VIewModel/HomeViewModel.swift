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
    }
    
    func profileClicked() {
        coordinatorDelegate?.goToProfile()
    }
}

extension HomeViewModel: ItemProviderProtocol {
    
    func getNumberOfItems(in section: Int) -> Int {
        0
    }
    
    func itemSelected(at index: Int) {
        //
    }
    
    func askData(for index: Int) -> DataProtocol? {
        nil
    }
}
