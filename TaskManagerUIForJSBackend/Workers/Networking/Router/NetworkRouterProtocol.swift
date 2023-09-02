//
//  NetworkRouterProtocol.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import UIKit
import Alamofire

protocol NetworkRouterProtocol: URLRequestConvertible {
  var method: HTTPMethod {get}
  var params: [String: Any] {get}
  var url: URL {get}
  var encoding: ParameterEncoding {get}
}

extension NetworkRouter {

  var encoding: ParameterEncoding {
    return method.defaultEncoding
  }

  func asURLRequest() throws -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    return try encoding.encode(urlRequest, with: params)
  }

}
