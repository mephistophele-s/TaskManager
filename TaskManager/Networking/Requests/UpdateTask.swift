//
//  UpdateTask.swift
//  TaskManager
//
//  Created by Anastasia on 14.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class UpdateTask: RequestType {
   
    typealias ResponseType = Array<Task>
  
    let data: RequestData
    let path = "/tasks/"
    let method: HTTPMethod = .put
    
    init(task: Task) {
        let token = DataManager.instance.currentUser?.token ?? ""
        let json = try! JSONEncoder().encode(task)
        let params = try! JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer " + token,  "accept": "application/json"]
        data = RequestData(path: path + "\(task.id)", method: method, params: params, headers: headers)
    }
}
