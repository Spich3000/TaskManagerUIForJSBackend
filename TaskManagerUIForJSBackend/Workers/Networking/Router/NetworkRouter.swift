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
}

extension NetworkRouter: NetworkRouterProtocol {
  var params: [String : Any] {
    var params = [String: Any]()
    switch self {
    case .getTasks:
      params[""] = ""
    default:
       break
    }
    return params
  }

  // MARK: Выстраивание пути запроса
  var url: URL {
    var endPoint = ""
    switch self {
    case .getTasks:
      endPoint = Constants.Endpoints.tasks
    }
    let url = URL(string: Constants.host)!.appendingPathComponent(endPoint)
    return url
  }

  var method: HTTPMethod {
    switch self {
    case .getTasks:
      return .get
    }
  }

  
}
