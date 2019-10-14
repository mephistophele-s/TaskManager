//
//  MainCoordinator .swift
//  TaskManager
//
//  Created by Anastasia on 12.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class MainCoordinator {

    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: false)
    }

    func showTaskList() {
        let taskListVC = TaskListViewController()
        taskListVC.coordinator = self
        navigationController.pushViewController(taskListVC, animated: true)
    }
    
    func showTaskDetails(taskId: Int) {
        let taskDetailsVC = TaskDetailsViewController(taskId: taskId)
        taskDetailsVC.coordinator = self
        navigationController.pushViewController(taskDetailsVC, animated: true)
    }
    
    func showEdit(task: Task) {
        let viewModel = EditTaskViewModel(task: task)
        let editTaskVC = EditTaskViewController(viewModel: viewModel)
        editTaskVC.coordinator = self
        navigationController.pushViewController(editTaskVC, animated: true)
    }
    
    func showCreate() {
        let viewModel = CreateTaskViewModel()
        let createTaskVC = EditTaskViewController(viewModel: viewModel)
        createTaskVC.coordinator = self
        navigationController.pushViewController(createTaskVC, animated: true)
    }
}
