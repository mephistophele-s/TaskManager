//
//  DeleteTask.swift
//  TaskManager
//
//  Created by Anastasia on 14.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class DeleteTask: RequestType {

    typealias ResponseType = Array<Task>

    let data: RequestData
    let path = "/tasks/"
    let method: HTTPMethod = .delete

    init(id: Int) {
        let token = DataManager.instance.currentUser?.token ?? ""
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer " + token]
        data = RequestData(path: path + "\(id)", method: method, headers: headers)
    }
}
