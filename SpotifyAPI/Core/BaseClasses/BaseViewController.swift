//
//  BaseViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldas on 20/05/2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var spinner: UIActivityIndicatorView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    /// Make setup configurations here. Only called once in viewDidLoad
    /// Override this method and call the super.
    func setup() {
        setupSpinner()
    }
    
    private func setupSpinner() {
        spinner.hidesWhenStopped = true
        
        view.addSubview(spinner)
        // set constraints to always in the middle of button
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @MainActor
    func updateLoader(_ isLoading: Bool) {
        if isLoading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
}
