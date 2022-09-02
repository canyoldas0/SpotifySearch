//
//  Alert.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

struct Alert: Equatable {
    let title: String
    let message: String
    let actions: [AlertAction]
}

struct AlertAction: Equatable {
    
    let title: String
    let style: UIAlertAction.Style
    let action: () -> Void?
    
    init(
        title: String,
        style: UIAlertAction.Style,
        action: @autoclosure @escaping () -> Void? = nil
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        lhs.title == rhs.title
    }
}

extension Alert {
    
    static func buildDefaultAlert(
        message: String? = nil,
        doneTitle: String? = nil,
        action: @autoclosure @escaping () -> Void? = nil,
        cancelAction: VoidHandler? = nil
    ) -> Alert {
        var actions: [AlertAction] = []
        let doneAction = AlertAction(title: doneTitle ?? "OK", style: .default, action: action())
        actions.append(doneAction)
        
        if let cancelAction {
            let action = AlertAction(title: "cancel", style: .cancel, action: cancelAction())
            actions.append(action)
        }
        
        return Alert(
            title: "Error",
            message: message ?? "Something went wrong.",
            actions: actions
        )
    }
}
