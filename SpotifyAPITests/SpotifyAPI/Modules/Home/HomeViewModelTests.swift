//
//  HomeViewModelTests.swift
//  SpotifyAPITests
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation
import XCTest
@testable import SpotifyAPI

final class HomeViewModelTests: XCTestCase {
    
    private var sut: HomeViewModel!
    private var mockSearch: MockSearchService!
    private var authManager: MockAuthManager!
    private var coordinatorDelegate: MockCoordinator!
    private var viewDelegate: MockViewController!

    
    override func setUp() {
        coordinatorDelegate = MockCoordinator()
        let observationManager = ObservationManager()
        
        viewDelegate = MockViewController()
        
        mockSearch = MockSearchService()
        authManager = MockAuthManager(observationManager: observationManager)
        sut = HomeViewModel(
            searchService: mockSearch,
            authManager: authManager,
            observationManager: observationManager
        )
        sut.coordinatorDelegate = coordinatorDelegate
        sut.delegate = viewDelegate
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        mockSearch = nil
        coordinatorDelegate = nil
        viewDelegate = nil
        super.tearDown()
    }
    
    func testSearchData() {
        // When
        sut.searchTracks(with: "test")
        
        // Then
        XCTAssertTrue(mockSearch.searchCalled)
    }
    
    func testSearchWithShortText() {
        // When
        sut.searchTracks(with: "1")
        
        let alert = Alert.buildDefaultAlert(message:"Search text should have minimum of 3 characters.")
        
        // Then
        XCTAssertEqual([HomeViewOutput.showAlert(alert)], viewDelegate.outputs)
    }
    
    func testLoadOnLoggedOut() {
        // When
        sut.load()
        
        // Then
        XCTAssertEqual(viewDelegate.outputs, [.updateTable, .updateProfileIcon(false)])
        XCTAssertTrue(coordinatorDelegate.goToLoginCalled)
    }
    
    func testProfileClicked() {
        // When
        sut.profileClicked()
        
        // Then
        XCTAssertTrue(coordinatorDelegate.goToProfileClicked)
    }
    
    func testMoreMenuClicked() {
        // When
        sut.moreMenuClicked()
        let alert = Alert.buildMoreMenu(actions: [.init(title: "Remove Image Cache", style: .default)])
        
        // Then
        XCTAssertEqual(viewDelegate.outputs, [.showAlert(alert)])
    }
}

// MARK: Mock View Controller
fileprivate final class MockViewController: HomeViewOutputProtocol {
    
    var outputs: [HomeViewOutput] = []
    
    func handleOutput(_ output: SpotifyAPI.HomeViewOutput) {
        outputs.append(output)
    }
}

// MARK: Mock Coordinator

fileprivate final class MockCoordinator: HomeCoordinatorDelegate {
    
    var goToLoginCalled = false
    var goToProfileClicked = false
    
    func goBack(completion: SpotifyAPI.VoidHandler?) { }
    
    func goToOnboardingLogin() {
        goToLoginCalled = true
    }
    
    func goToProfile(animated: Bool) {
        goToProfileClicked = true
    }
    
    func goToDetail(animated: Bool, with id: String) { }
    
    func goToAuthScreen(animated: Bool) { }
    
    func returnHome(completion: SpotifyAPI.VoidHandler?) { }
    
}

// MARK: Mock Search Service
fileprivate final class MockSearchService:  SearchServiceProtocol {
    
    var searchCalled = false
    
    func search(request: SpotifyAPI.Requestable, completion: @escaping (Result<SpotifyAPI.SearchResponse, Error>) -> Void) {
        searchCalled = true
    }
}

// MARK: Mock Auth Manager
fileprivate class MockAuthManager: AuthManagerProtocol {
    
    var observationManager: SpotifyAPI.ObservationManagerProtocol
    
    init(observationManager: SpotifyAPI.ObservationManagerProtocol) {
        self.observationManager = observationManager
    }
    
    func isSignedIn() -> Bool {
        false
    }
    
    func getSignInUrl() -> URL? {
        nil
    }
    
    func removeCacheIfNeeded() { }
    
    func logout() { }
    
    func exchangeCodeForToken(code: String, completion: @escaping SpotifyAPI.GenericHandler<Bool>) {
        //
    }
    
    func fetchData<T>(
        endpoint: String,
        httpMethod: SpotifyAPI.HTTPMethod,
        requestable: SpotifyAPI.Requestable,
        completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
        //
    }
    
    
}
