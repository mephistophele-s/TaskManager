//
//  GetTask.swift
//  TaskManager
//
//  Created by Anastasia on 14.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class GetTask: RequestType {

    typealias ResponseType = TaskResponse

    let data: RequestData
    let path = "/tasks/"
    let method: HTTPMethod = .get

    init(id: Int) {
        let token = DataManager.instance.currentUser?.token ?? ""
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer " + token]
        data = RequestData(path: path + "\(id)", method: method, headers: headers)
    }
}

struct TaskResponse: Codable {

    let task: Task

    enum CodingKeys: String, CodingKey {
        case task = "task"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        task = try container.decode(Task.self, forKey: .task)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(task, forKey: .task)
    }
}
