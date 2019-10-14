//
//  Task.swift
//  TaskManager
//
//  Created by Anastasia on 10/5/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

enum TaskCodingError: Error {
    case invalidPriority
    case invalidDate
    case invalidId
}

struct Task: Codable {
    
    let id: Int
    let title: String
    let description: String
    let date: Date
    let priority: Priority
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case id = "id"
        case date = "dueBy"
        case priority = "priority"
    }
    
    init(id: Int, title: String, date: Date, priority: Priority) {
        self.id = id
        self.title = title
        self.date = date
        self.priority = priority
        self.description = "There is no description field on backend :("
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
        
        let dateInt = Int(date.timeIntervalSince1970)
        try container.encode(dateInt, forKey: .date)
        try container.encode(priority.description, forKey: .priority)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        
        let priorityString = try container.decode(String.self, forKey: .priority)
    
        guard let priority_ = Priority.from(string: priorityString) else {
            throw TaskCodingError.invalidPriority
        }
        priority = priority_
        
        let dateInt = try container.decode(Int.self, forKey: .date)
        let timeInterval = TimeInterval(dateInt)
        date = Date(timeIntervalSince1970: timeInterval)

        id = try container.decode(Int.self, forKey: .id)
        
        description = "There is no description field on backend :("
    }
}




