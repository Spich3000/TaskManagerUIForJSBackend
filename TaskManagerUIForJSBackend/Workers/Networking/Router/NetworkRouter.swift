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
}

extension NetworkRouter: NetworkRouterProtocol {
    var params: [String : Any] {
        var params = [String: Any]()
        switch self {
        case let .createTask(name):
            params["name"] = name
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
        case .deleteTask:
            return .delete
        }
    }
    
    
}
