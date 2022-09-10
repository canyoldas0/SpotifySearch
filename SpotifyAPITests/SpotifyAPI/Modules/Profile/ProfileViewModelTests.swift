//
//  ProfileViewModel.swift
//  SpotifyAPITests
//
//  Created by Can Yoldaş on 10.09.2022.
//

import Foundation
import XCTest
@testable import SpotifyAPI

final class ProfileViewModelTests: XCTestCase {
    
    private var sut: ProfileViewModel!
    private var mockProfile: MockProfileService!
    private var authManager: MockAuthManager!
    private var coordinatorDelegate: MockCoordinator!
    private var viewDelegate: MockViewController!

    
    override func setUp() {
        coordinatorDelegate = MockCoordinator()
        let observationManager = ObservationManager()
        
        viewDelegate = MockViewController()
        
        mockProfile = MockProfileService()
        authManager = MockAuthManager(observationManager: observationManager)
        sut = ProfileViewModel(authManager: authManager,
                               profileService: mockProfile)
        sut.coordinatorDelegate = coordinatorDelegate
        sut.delegate = viewDelegate
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        mockProfile = nil
        coordinatorDelegate = nil
        viewDelegate = nil
        super.tearDown()
    }
    
    func testLoadOnSignedIn() {
        // When
        mockProfile.isFetchSuccess = true
        authManager.signedIn = true
        sut.load()
        
        // Then
        XCTAssertEqual(viewDelegate.outputs, [.updateView(signedIn: true, data: .stub())])
    }
    
    func testLoadOnSignedOut() {
        // When
        authManager.signedIn = false
        sut.load()
        
        // Then
        XCTAssertEqual(viewDelegate.outputs, [.updateView(signedIn: false, data: nil)])
    }
    
    func testLoadOnFetchError() {
        // When
        authManager.signedIn = true
        mockProfile.isFetchSuccess = false
        sut.load()
        
        XCTAssertEqual(viewDelegate.outputs, [.showAlert(Alert.buildDefaultAlert(message: NetworkError.decodingFailed.rawValue))])
    }
}

fileprivate final class MockViewController: ProfileViewOutputProtocol {
    
    var outputs: [ProfileViewOutput] = []
    
    func handleOutput(_ output: SpotifyAPI.ProfileViewOutput) {
        outputs.append(output)
    }
}

fileprivate final class MockCoordinator: HomeCoordinatorDelegate {
    
    var goToLoginCalled = false
    var goToProfileClicked = false
    
    func goBack(completion: SpotifyAPI.VoidHandler?) { }
    
    func goToLogin() {
        goToLoginCalled = true
    }
    
    func goToProfile() {
        goToProfileClicked = true
    }
    
    func goToDetail(animated: Bool, with id: String) { }
    
    func goToAuthScreen() { }
    
    func returnHome(completion: SpotifyAPI.VoidHandler?) { }
    
    func goToRoot(completion: SpotifyAPI.VoidHandler?) { }

}

fileprivate final class MockProfileService: ProfileServiceProtocol {
    
    var isFetchSuccess = true
    
    func fetchProfileData(request: SpotifyAPI.Requestable, completion: @escaping (Result<SpotifyAPI.ProfileResponse, Error>) -> Void) {
        
        if isFetchSuccess {
            completion(.success(.stub()))
        } else {
            completion(.failure(NetworkError.decodingFailed))
        }
    }
    
    
}

fileprivate class MockAuthManager: AuthManagerProtocol {
    
    var observationManager: SpotifyAPI.ObservationManagerProtocol
    
    var signedIn = false
    
    init(observationManager: SpotifyAPI.ObservationManagerProtocol) {
        self.observationManager = observationManager
    }
    
    func isSignedIn() -> Bool {
        signedIn
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
