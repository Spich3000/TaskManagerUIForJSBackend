//
//  Model+Error.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import Foundation

enum TaskModel {
    struct Task: Codable {
        var tasks: [TaskElement]?
    }
    
    struct TaskElement: Codable {
        var completed: Bool
        var id: String
        var name: String
        var v: Int?
        
        enum CodingKeys: String, CodingKey {
            case completed
            case id = "_id"
            case name
            case v = "__v"
        }
    }
}

//MARK: - Error
//enum AuthenticationError: Error {
//    case invalidCredentials
//    case custom(errorMessage: String)
//}
