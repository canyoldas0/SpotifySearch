//
//  HomeCoordinatorTests.swift
//  SpotifyAPITests
//
//  Created by Can Yoldaş on 8.09.2022.
//

import Foundation
import XCTest
@testable import SpotifyAPI

final class HomeCoordinatorTests: XCTestCase {
    
    private var sut: HomeCoordinator!
    private var window: UIWindow!
    private var parentCoordinator: MockParentCoordinator!
    
    override func setUp() {
        window = UIWindow()
        
        let dependencies = DependencyContainer(
            window: window,
            apiConfiguration: URLSessionConfiguration.default,
            observationManager: ObservationManager()
        )
        parentCoordinator = MockParentCoordinator()
        sut = HomeCoordinator(dependencies: dependencies)
        sut.parentCoordinator = parentCoordinator
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testStartOfCoordinator() {
        // When
        sut.start()
        
        // Then
        XCTAssertNotNil(sut.rootViewController)
        XCTAssertTrue(sut.rootViewController.viewControllers.first is HomeViewController)
    }
    
    func testChildDidFinish() {
        // When
        sut.dismiss()
        
        // Then
        XCTAssertTrue(parentCoordinator.childDidFinishedCalled)
    }
    
    func testGoToLogin() {
        // Given
        sut.start()
        window.rootViewController = sut.rootViewController
        window.makeKeyAndVisible()
        
        // When
        sut.goToLogin()
        
        // Then
        XCTAssertTrue(sut.rootViewController.presentedViewController is SignInViewController)
    }
}

fileprivate class MockParentCoordinator: ParentCoordinatorDelegate {
    
    var children: [CoordinatorProtocol] = []
    
    var childDidFinishedCalled = false
    
    func childDidFinish(child: CoordinatorProtocol) {
        childDidFinishedCalled = true
    }
    
}
