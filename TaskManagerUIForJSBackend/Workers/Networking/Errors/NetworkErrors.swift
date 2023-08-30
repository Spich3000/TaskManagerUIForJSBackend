//
//  NetworkErrors.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import Foundation

struct NetworkingResponseError: Decodable {
  let msg: String
}

extension NetworkManager {

  enum Error: Swift.Error {
    case errorWithMessage(NetworkingResponseError)
    case decodingError(error: Swift.Error)
    case badRequest
    case internalServerError
    case undefinedError
  }

}

extension NetworkManager.Error: LocalizedError {

  var errorDescription: String? {
    switch self {
    case .errorWithMessage(let message):
      return "Error message from backend: --- \(message.msg) ---"
    case .decodingError(let error):
      return "Error catched: \(error.localizedDescription)"
    case .badRequest:
      return "Bad network request!"
    case .internalServerError:
      return "Internal server error!"
    case .undefinedError:
      return "Undefined error!"
    }
  }

}
