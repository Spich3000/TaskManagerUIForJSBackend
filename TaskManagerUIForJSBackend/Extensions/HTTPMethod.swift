//
//  HTTPMethod.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import Alamofire

extension HTTPMethod {
  var defaultEncoding: ParameterEncoding {
    switch self {
    case .get, .delete:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
}
