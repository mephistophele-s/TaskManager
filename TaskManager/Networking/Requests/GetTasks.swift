//
//  GetTasks.swift
//  TaskManager
//
//  Created by Anastasia on 13.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class GetTasks: RequestType {
   
    typealias ResponseType = TasksResponse
  
    let data: RequestData
    let path = "/tasks"
    let method: HTTPMethod = .get
    
    init(sortOrder: SortOrder, sortOption: SortOption) {
        let token = DataManager.instance.currentUser?.token ?? ""
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer " + token]
        data = RequestData(path: path + "?sort=\(sortOption.description)%20\(sortOrder)", method: method, headers: headers)
    }
}

struct TasksResponse: Codable {

    let tasks: [Task]

    enum CodingKeys: String, CodingKey {
        case tasks = "tasks"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tasks = try container.decode([Task].self, forKey: .tasks)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tasks, forKey: .tasks)
    }
}
