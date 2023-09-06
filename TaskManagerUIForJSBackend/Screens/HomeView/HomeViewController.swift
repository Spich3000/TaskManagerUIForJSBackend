//
//  ViewController.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController  {
    
    var viewModel: HomeViewModelProtocol
    
    private let dataProvider: TableViewDataProvider
    
    init(
        viewModel: HomeViewModelProtocol
    ) {
        self.viewModel = viewModel
        self.dataProvider = .init(tableView: tableView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private let alertCreateTask = UIAlertController(
        title: "Add task!",
        message: nil,
        preferredStyle: .alert)
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .large
        loader.hidesWhenStopped = true
        loader.color = .black
        return loader
    }()
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.2
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        dataProvider.action = { task in
            self.navigationController?.pushViewController(DetailViewController(task: task), animated: true)
        }
        
        self.enableLoader(on: true)

        self.viewModel.getTasks() {
            self.tableView.reloadData()
            self.enableLoader(on: false)
        }
            
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        self.title = "Task Manager"
        
        tableView.frame = view.bounds
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        tableView.refreshControl = refreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")

        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        alertCreateTask.addTextField { textField in
            textField.placeholder = "Enter Task..."
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { [weak alertCreateTask] _ in
            guard let textFields = alertCreateTask?.textFields else {
                return
            }
            
            if let taskText = textFields[0].text, !taskText.isEmpty, taskText.count < 21 {
                self.enableLoader(on: true)
                self.viewModel.createTask(name: taskText) {
                    self.enableLoader(on: false)
                    self.tableView.reloadData()
                }
            }
        }
        
        alertCreateTask.addAction(continueAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        loader.center = view.center
        background.frame = view.bounds

        view.addSubview(background)
        view.addSubview(loader)
    }
        
    @objc func addTask() {
        print("")
        self.present(alertCreateTask, animated: true)
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        self.viewModel.getTasks() {
            self.tableView.reloadData()
        }
        sender.endRefreshing()
    }

    private func enableLoader(on: Bool) {
        if on {
            loader.startAnimating()
            background.isHidden = false
        } else {
            loader.stopAnimating()
            background.isHidden = true
        }
    }

}

/// Preview
struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        Group {
            HomeViewController(viewModel: HomeViewModel()).preview()
        }
    }
}


