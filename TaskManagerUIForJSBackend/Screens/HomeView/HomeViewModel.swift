//
//  HomeViewModel.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 07.09.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var dataArray: [TaskModel.TaskElement] { get set }
    
    func deleteTask(_ index: IndexPath)
    func getTasks(completion: @escaping () -> Void)
    func createTask(name: String, completion: @escaping () -> Void)
}

final class HomeViewModel: HomeViewModelProtocol {
    var dataArray: [TaskModel.TaskElement] = []
    
    func deleteTask(_ index: IndexPath) {
        let id = dataArray[index.row].id
        let request = NetworkRouter.deleteTask(id: id)
        NetworkManager.request(request) { (result: Result<TaskModel.Task, NetworkManager.Error>) in
            switch result {
            case .success(_):
                print("success deleting")
            case .failure(let failure):
                print(failure.errorDescription as Any)
            }
        }
    }
    
    func getTasks(completion: @escaping () -> Void) {
        let request = NetworkRouter.getTasks
        NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
            switch result {
            case .success(let success):
                self?.dataArray = success.tasks ?? []
            case .failure(let failure):
                print(failure.errorDescription as Any)
            }
            completion()
        }
    }
    
    func createTask(name: String, completion: @escaping () -> Void) {
        let request = NetworkRouter.createTask(name: name)
        NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
            switch result {
            case .success(_):
                self?.getTasks() {
                    completion()
                }
            case .failure(let failure):
                print(failure.errorDescription as Any)
            }
        }
    }
}
