//
//  TaskDetailsViewController.swift
//  TaskManager
//
//  Created by Anastasia on 10/12/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    private var taskId: Int
    private var task: Task?
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDueDateLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskNotificationLabel: UILabel!
    
    init(taskId: Int) {
        self.taskId = taskId
        super.init(nibName: "TaskDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetTask(id: taskId).execute(onSuccess: { response in
            self.task = response.task
            self.setUpAppearence(task: response.task)
        }) { error in
            print("task details getting error: \(error)")
        }
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        DeleteTask(id: taskId).execute(onSuccess: { _ in
            self.coordinator?.navigationController.popViewController(animated: true)
        }) { error in
            print("deleting error: \(error)")
        }
    }
}

private extension TaskDetailsViewController {
    
    func setUpAppearence(task: Task) {
        taskTitleLabel.text = task.title
        taskPriorityLabel.text = "\(task.priority)"
        taskDescriptionLabel.text = task.description

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMM, yyyy"
        taskDueDateLabel.text = dateFormatter.string(from: task.date)
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "Task Details"
        navigationItem.rightBarButtonItem = rightNavigationItem()
    }
    
    func rightNavigationItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTask))
    }
    
    @objc func editTask() {
        guard let task_ = task else { return }
        coordinator?.showEdit(task: task_)
    }
}
