//
//  NetworkRouter.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import UIKit
import Alamofire

enum NetworkRouter {
    case getTasks
    case createTask(name: String)
    case deleteTask(id: String)
    case updateTask(task: TaskModel.TaskElement)
}

extension NetworkRouter: NetworkRouterProtocol {
    var params: [String : Any] {
        var params = [String: Any]()
        switch self {
        case let .createTask(name):
            params["name"] = name
        case let .updateTask(task):
            params["name"] = task.name
            params["completed"] = task.completed
        default:
            break
        }
        return params
    }
    
    // MARK: Выстраивание пути запроса
    var url: URL {
        var endPoint = ""
        switch self {
        case .getTasks, .createTask:
            endPoint = Constants.Endpoints.tasks
        case let .deleteTask(id):
            endPoint = Constants.Endpoints.tasks + "/\(id)"
        case let .updateTask(task):
            endPoint = Constants.Endpoints.tasks + "/\(task.id)"
        }
        let url = URL(string: Constants.host)!.appendingPathComponent(endPoint)
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTasks:
            return .get
        case .createTask:
            return .post
        case .updateTask:
            return .patch
        case .deleteTask:
            return .delete
        }
    }
    
    
}
