//
//  NetworkManager.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import Foundation
import Alamofire

final class NetworkManager {

  @discardableResult
  static func request<T: Decodable>(
    _ urlRequest: URLRequestConvertible,
    result: @escaping (Result<T, Error>) -> Void
  ) -> Request {

    return AF.request(urlRequest).responseData { response in
      guard let code = response.response?.statusCode,
          let data = response.value else {
        return
      }
      let url = urlRequest.urlRequest?.url?.absoluteString ?? ""
      let decoder = JSONDecoder()

      switch code {
      case 200..<300:
        do {
          let object = try decoder.decode(T.self, from: data)
          result(.success(object))
          return
        } catch {
          result(.failure(.decodingError(error: error)))
          print("Url: \(url). Code: \(code).")
        }
        print("Url: \(url). Code: \(code).")

      case 400:
        if let error = try? decoder.decode(NetworkingResponseError.self, from: data) {
          result(.failure(.errorWithMessage(error)))
        } else {
          result(.failure(.undefinedError))
        }
        print("Url: \(url). Code: \(code).")

      case 404:
        if let error = try? decoder.decode(NetworkingResponseError.self, from: data) {
          result(.failure(.errorWithMessage(error)))
        } else {
          result(.failure(.badRequest))
        }
        print("Url: \(url). Code: \(code).")


      case 500..<600:
        result(.failure(.internalServerError))
        print("Url: \(url). Code: \(code).")

      default:
        if let error = try? decoder.decode(NetworkingResponseError.self, from: data) {
          result(.failure(.errorWithMessage(error)))
        } else {
          do {
            let object = try decoder.decode(T.self, from: data)
            result(.success(object))
            return
          } catch {
            result(.failure(.decodingError(error: error)))
          }
        }
        print("Url: \(url). Code: \(code).")
      }
    }
  }

}
