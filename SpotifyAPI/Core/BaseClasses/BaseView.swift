//
//  BaseView.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

class BaseView<T>: UIView {
    
    private var data: T?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(frame: CGRect = .zero, data: T? = nil) {
        self.data = data
        super.init(frame: frame)
        setupViews()
        loadDataToView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setData(data: T?) {
        self.data = data
        loadDataToView()
    }
    
    func returnData() -> T? {
        return data
    }
    
    func setupViews() {}
    
    func loadDataToView() { }
}
