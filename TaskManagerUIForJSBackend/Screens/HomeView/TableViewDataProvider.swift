//
//  TableViewDataProvider.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 07.09.2023.
//

import Foundation
import UIKit

final class TableViewDataProvider: NSObject {
    private let tableView: UITableView
    private var viewModel: HomeViewModelProtocol
    var action: ((TaskModel.TaskElement) -> Void)? = nil
    
    init(
        tableView: UITableView,
        viewModel: HomeViewModelProtocol
    ) {
        self.tableView = tableView
        self.viewModel = viewModel
    }
}

extension TableViewDataProvider: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let item = viewModel.dataArray[indexPath.row]
        
        cell.accessoryType = item.completed ? .checkmark : .none
        cell.textLabel?.text = item.name
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        action?(viewModel.dataArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.deleteTask(indexPath)
            viewModel.dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
