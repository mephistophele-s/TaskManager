//
//  EditTaskViewModelType.swift
//  TaskManager
//
//  Created by Anastasia on 13.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

protocol EditTaskViewModelType {
    
    var task: Task? { get }
    var navigationTitle: String { get }
    
    func done(title: String, date: String, priority: String, completionHandler: @escaping () -> Void)
}

extension EditTaskViewModelType {
    
    func task(from title: String, dateString: String, priorityString: String) -> Task {
        let id = task?.id ?? -1

        let date: Date
        if let actualDate = DateFormatter.defaultFormatter.date(from: dateString) {
           date = actualDate
        } else {
           date = Date()
        }
               
        let priority: Priority
        if let priority_ = Priority.from(string: priorityString) {
           priority = priority_
        } else {
           priority = .low
        }
               
        return Task(id: id, title: (title.isEmpty ? "Title" : title), date: date, priority: priority)
    }
}

class CreateTaskViewModel: EditTaskViewModelType {
    
    var task: Task?
    var navigationTitle: String = "Create task"
    
    func done(title: String, date: String, priority: String, completionHandler: @escaping () -> Void) {
        let newTask = task(from: title, dateString: date, priorityString: priority)
        CreateTask(task: newTask).execute(onSuccess: { _ in
            completionHandler()
        }) { error in
            print("creating task error \(error)")
        }
    }
}

class EditTaskViewModel: EditTaskViewModelType {

    let task: Task?
    let navigationTitle: String = "Edit task"
    
    init(task: Task) {
        self.task = task
    }
    
    func done(title: String, date: String, priority: String, completionHandler: @escaping () -> Void) {
       let newTask = task(from: title, dateString: date, priorityString: priority)
       
        UpdateTask(task: newTask).execute(onSuccess: { _ in
            completionHandler()
        }) { error in
            print("updating task error \(error)")
        }
    }
}
