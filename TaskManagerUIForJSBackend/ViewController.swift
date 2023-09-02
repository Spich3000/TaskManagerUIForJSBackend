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
    private let alertCreateTask = UIAlertController(
        title: "Add task!",
        message: nil,
        preferredStyle: .alert)
    
    // Kinda onAppear??
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        getTasks()
        
        self.title = "Task Manager"
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        alertCreateTask.addTextField { textField in
            textField.placeholder = "Enter Task..."
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { [weak alertCreateTask] _ in
            guard let textFields = alertCreateTask?.textFields else { return }
            
            if let taskText = textFields[0].text {
                let request = NetworkRouter.createTask(name: taskText)
                NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
                    switch result {
                    case .success(_):
                        self?.getTasks()
                    case .failure(let failure):
                        print(failure.errorDescription as Any)
                    }
                }
            }
        }
        
        alertCreateTask.addAction(continueAction)
    }
    
    @objc func addTask() {
        print("")
        self.present(alertCreateTask, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count // Replace dataArray with your data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let item = dataArray[indexPath.row]
        if (dataArray[indexPath.row].completed ?? false) {
            cell.imageView?.image = UIImage(systemName: "checkmark.circle")
        }
        cell.textLabel?.text = item.name // Customize this based on your data structure
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        navigationController?.pushViewController(DetailViewController(task: dataArray[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(indexPath)
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            getTasks()
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
                    self?.tableView.reloadData()
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
                self?.dataArray = success.tasks ?? []
                self?.tableView.reloadData() // Reload the table view once data is fetched
            case .failure(let failure):
                print(failure.errorDescription as Any)
            }
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


