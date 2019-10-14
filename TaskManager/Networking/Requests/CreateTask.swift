//
//  CreateTask.swift
//  TaskManager
//
//  Created by Anastasia on 14.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class CreateTask: RequestType {

    typealias ResponseType = [String: Task]

    let data: RequestData
    let path = "/tasks"
    let method: HTTPMethod = .post

    init(task: Task) {
        let token = DataManager.instance.currentUser?.token ?? ""
        let json = try! JSONEncoder().encode(task)
        let params = try! JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer " + token]
        data = RequestData(path: path, method: method, params: params, headers: headers)
    }
}
