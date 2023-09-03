//
//  ViewController.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import UIKit
import SwiftUI

// View + states
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataArray: [TaskModel.TaskElement] = []
    
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
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        getTasks()
        
//        refreshControl.attributedTitle = NSAttributedString(string: String())
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        self.title = "Task Manager"
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        alertCreateTask.addTextField { textField in
            textField.placeholder = "Enter Task..."
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { [weak alertCreateTask] _ in
            guard let textFields = alertCreateTask?.textFields else {
                return
            }
            
            if let taskText = textFields[0].text {
                let request = NetworkRouter.createTask(name: taskText)
                
                self.enableLoader(on: true)

                NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
                    switch result {
                    case .success(_):
                        self?.getTasks()
                    case .failure(let failure):
                        print(failure.errorDescription as Any)
                    }
                    self?.enableLoader(on: false)
                }
            }
        }
        
        alertCreateTask.addAction(continueAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        // Perform your data refresh logic here
        getTasks()
        // After data is refreshed, end the refreshing state
        sender.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count // Replace dataArray with your data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let item = dataArray[indexPath.row]
        
        if let completed = item.completed, completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = item.name // Customize this based on your data structure
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        print(dataArray[indexPath.row].name)
        navigationController?.pushViewController(DetailViewController(task: dataArray[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(indexPath)
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func deleteTask(_ index: IndexPath) {
        if let id = dataArray[index.row].id {
            let request = NetworkRouter.deleteTask(id: id)
            NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
                switch result {
                case .success(_):
                    print("success deleting")
                case .failure(let failure):
                    print(failure.errorDescription as Any)
                }
            }
        }
    }
    
    func getTasks() {
        let request = NetworkRouter.getTasks
        NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.dataArray = success.tasks ?? []
                    self?.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure.errorDescription as Any)
            }
        }
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
            ViewController().preview()
        }
    }
}


