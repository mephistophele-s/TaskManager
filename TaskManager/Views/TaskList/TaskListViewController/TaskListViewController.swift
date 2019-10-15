//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by Anastasia on 10/5/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    private var sortView = SortView(origin: CGPoint(x: 0, y: 0))
    private let orderButton = UIButton(type: .custom)
    private var sortOrder: SortOrder = defaultSorting.order
    private var sortOption: SortOption =  defaultSorting.option
    
    private let cellId = "TaskTableViewCell"
  
    private var tasks: [Task] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
        setUpSortView()
        setUpRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetTasks(sortOrder: sortOrder, sortOption: sortOption).execute(onSuccess: { response in
            self.tasks = response.tasks
        }) { error in
            print("updating tasks error: \(error)")
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        coordinator?.showCreate()
    }
}

extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell
        if let task = cell?.task {
            coordinator?.showTaskDetails(taskId: task.id)
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TaskTableViewCell {
            cell.task = tasks[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
}

extension TaskListViewController: SortViewDelegate {
    
    func didChangeSortOption(option: SortOption) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.sortView.isHidden = true
        }
        sortOption = option
        let sortedTasks = sortTasks(by: option, order: sortOrder)

        updateTasks(sortedTasks)
    }
}

private extension TaskListViewController {
    
    func sortTasks(by option: SortOption, order: SortOrder) -> [Task] {
        let sortedTasks: [Task]
        switch option {
        case .date:
            sortedTasks = tasks.sorted(by: { $0.date > $1.date })
        case .priority:
            sortedTasks = tasks.sorted(by: { $0.priority > $1.priority })
        case .title:
            sortedTasks = tasks.sorted(by: { $0.title > $1.title })
        }
        
        if order == .desc {
            return sortedTasks.reversed()
        }
        
        return sortedTasks
    }
    
    func updateTasks(_ newTasks: [Task]) {
        tableView.performBatchUpdates({ () -> Void in
            for (newIndex, task) in newTasks.enumerated() {
                guard let oldIndex = tasks.firstIndex(where: { $0.id == task.id }) else { continue }
                let fromIndexPath = IndexPath(row: oldIndex, section: 0)
                let toIndexPath = IndexPath(row: newIndex, section: 0)
                
                tableView.moveRow(at: fromIndexPath, to: toIndexPath)
            }
        }, completion: { finished in
            self.tasks = newTasks
        })
    }
    
    @objc func changeOrder() {
        
        switch sortOrder {
        case .asc:
            sortOrder = .desc
        case .desc:
            sortOrder = .asc
        }

        orderButton.setImage(sortOrder.image, for: .normal)
        updateTasks(tasks.reversed())
    }
    
    @objc func toggleSortView() {
        sortView.isHidden = !sortView.isHidden
    }
    
    @objc func refresh(sender: AnyObject) {
        GetTasks(sortOrder: sortOrder, sortOption: sortOption).execute(onSuccess: { response in
            self.tasks = response.tasks
            self.refreshControl.endRefreshing()
        }) { error in
            print("refreshing tasks error: \(error)")
        }
    }
}

private extension TaskListViewController {
    
    func setUpNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "My Tasks"
        navigationItem.leftBarButtonItem = leftNavigationItem()
        navigationItem.rightBarButtonItem = rightNavigationItem()
    }
    
    func rightNavigationItem() -> UIBarButtonItem {
        let optionButton = UIButton(type: .custom)
        optionButton.setImage(UIImage(named: "option"), for: .normal)
        optionButton.addTarget(self, action: #selector(toggleSortView), for: .touchUpInside)
        optionButton.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        optionButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        return UIBarButtonItem(customView: optionButton)
    }
    
    func leftNavigationItem() -> UIBarButtonItem {
        orderButton.setImage(UIImage(named: "sortUp"), for: .normal)
        orderButton.addTarget(self, action: #selector(changeOrder), for: .touchUpInside)
        orderButton.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        return UIBarButtonItem(customView: orderButton)
    }
    
    func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setUpTableView() {
        let cell = UINib(nibName: cellId, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setUpSortView() {
        let x = tableView.frame.width - 140
        sortView = SortView(origin: CGPoint(x: x, y: 54))
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.addSubview(sortView)
        sortView.isHidden = true
        sortView.delegate = self
    }
}
