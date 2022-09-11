//
//  DetailViewModel.swift
//  SpotifyAPITests
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation
import XCTest
@testable import SpotifyAPI

final class DetailViewModelTests: XCTestCase {
    
    private var sut: DetailViewModel!
    private var mockDetail: MockDetailService!
    private var authManager: MockAuthManager!
    private var coordinatorDelegate: MockCoordinator!
    private var viewDelegate: MockViewController!

    
    override func setUp() {
        coordinatorDelegate = MockCoordinator()
        let observationManager = ObservationManager()
        
        viewDelegate = MockViewController()
        
        mockDetail = MockDetailService()
        authManager = MockAuthManager(observationManager: observationManager)
        sut = DetailViewModel(
            itemId: "Test",
            detailService: mockDetail
        )
        sut.coordinatorDelegate = coordinatorDelegate
        sut.delegate = viewDelegate
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        mockDetail = nil
        coordinatorDelegate = nil
        viewDelegate = nil
        super.tearDown()
    }
    
    func testLoad() {
        // When
        sut.load()
        
        // Then
        XCTAssertEqual(viewDelegate.outputs, [
            .updateTitle("Test"),
            .updateHeader(.stub()),
            .updateAlbumData(.stub())
        ])
    }
}

fileprivate final class MockViewController: DetailViewOutputProtocol {
    
    var outputs: [DetailViewOutput] = []
    
    func handleOutput(_ output: SpotifyAPI.DetailViewOutput) {
        outputs.append(output)
    }
}

fileprivate final class MockCoordinator: HomeCoordinatorDelegate {
    
    var goToLoginCalled = false
    var goToProfileClicked = false
    
    func goBack(completion: SpotifyAPI.VoidHandler?) { }
    
    func goToOnboardingLogin() {
        goToLoginCalled = true
    }
    
    func goToProfile() {
        goToProfileClicked = true
    }
    
    func goToDetail(animated: Bool, with id: String) { }
    
    func goToAuthScreen(animated: Bool) { }
    
    func returnHome(completion: SpotifyAPI.VoidHandler?) { }
}

fileprivate final class MockDetailService:  DetailServiceProtocol {
    
    func fetchDetailData(itemId: String, request: SpotifyAPI.Requestable, completion: @escaping (Result<SpotifyAPI.DetailResponse, Error>) -> Void) {
        completion(.success(.stub()))
    }
    
    func fetchArtistAlbumData(itemId: String, request: SpotifyAPI.Requestable, completion: @escaping (Result<SpotifyAPI.AlbumResponse, Error>) -> Void) {
        completion(.success(.stub()))
    }
}

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
