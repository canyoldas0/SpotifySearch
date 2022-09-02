//
//  ProfileViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class ProfileViewController: UIViewController, ErrorHandlingProtocol {
    
    deinit {
        print("deinit profile")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
    }
}
