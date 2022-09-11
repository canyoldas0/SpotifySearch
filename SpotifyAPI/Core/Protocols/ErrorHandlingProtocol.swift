//
//  ErrorHandlingProtocol.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

protocol ErrorHandlingProtocol where Self: UIViewController {
    
    func showAlert(with alert: Alert)
    
}

extension ErrorHandlingProtocol {
    
    func showAlert(with alert: Alert) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
        
        alert.actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.action()
            }
            alertController.addAction(alertAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}
