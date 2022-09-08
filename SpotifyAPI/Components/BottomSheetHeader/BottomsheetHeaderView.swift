//
//  BottomsheetHeaderView.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import UIKit

struct BottomsheetHeaderData: GenericDataProtocol {
    let title: String?
    let buttonTitle: String?
    let dismissAction: VoidHandler?
    
    init(title: String?,
         buttonTitle: String? = "Dismiss",
         dismissAction: @escaping VoidHandler
    ) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.dismissAction = dismissAction
    }
}

final class BottomsheetHeaderView: BaseView<BottomsheetHeaderData> {
    
    private let titleLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = ""
        temp.font = .systemFont(ofSize: 16, weight: .semibold)
        temp.textAlignment = .center
        return temp
    }()
    
    private let dismissButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Dismiss", for: .normal)
        temp.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        temp.setTitleColor(.systemBlue, for: .normal)
        return temp
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
        
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        ])
    }
    
    override func setData(data: BottomsheetHeaderData?) {
        guard let data else {
            return
        }
        titleLabel.text = data.title
        dismissButton.setTitle(data.buttonTitle, for: .normal)
        dismissButton.addAction {
            data.dismissAction?()
        }
    }
}
