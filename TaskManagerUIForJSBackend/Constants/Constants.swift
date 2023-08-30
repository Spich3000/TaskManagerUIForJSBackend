//
//  Constants.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import Foundation

final class Constants {
    static let hostName: String = "45.141.101.186:5051"
    static let host: String = "http://\(hostName)"
    
    enum Endpoints {
      static let tasks = "/api/v1/tasks"
    }
}

/*
 http://45.141.101.186:5051/api/v1/tasks
 
 final class Constants {
   static let HOST_NAME = "jsonplaceholder.typicode.com"

   static let HOST = "https://\(HOST_NAME)"

   enum Endpoints {
     static let posts = "/posts"
   }
 }
 */
