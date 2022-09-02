//
//  ListView.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

/// Protocol that is used for providing data to list view.
/// It allows customView classes to conform its own tableview protocols
protocol ItemProviderProtocol: AnyObject {
    func getNumberOfItems(in section: Int) -> Int
    func itemSelected(at index: Int)
    func askData(for index: Int) -> DataProtocol?
}

/// Data object to customize ListView.
struct ListViewData { }

// MARK: ListView

final class ListView: BaseView<ListViewData> {
    
    weak var delegate: ItemProviderProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 130
        tableView.estimatedRowHeight = 130
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.identifier)
        return tableView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// This method can be used whenever parent view needs to notify list to update itself.
    func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: Tableview Delegates

extension ListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.getNumberOfItems(in: section) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as? ListViewCell,
              let data = delegate?.askData(for: indexPath.row) else {
            return UITableViewCell()
        }
        cell.setData(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectedBackgroundView = .none
        cell?.selectionStyle = .none
        delegate?.itemSelected(at: indexPath.row)
    }
}
