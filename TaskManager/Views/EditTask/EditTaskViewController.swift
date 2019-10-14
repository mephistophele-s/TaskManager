//
//  EditTaskViewController.swift
//  TaskManager
//
//  Created by Anastasia on 12.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    private let viewModel: EditTaskViewModelType
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: view.frame)
        picker.layer.backgroundColor = UIColor.white.cgColor
        picker.datePickerMode = .date
        
        if let task = self.viewModel.task {
            picker.date = task.date
        }
        
        return picker
    }()
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var priorityControl: UISegmentedControl!
    
    init(viewModel: EditTaskViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "EditTaskViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpAppearence()
    }
    
    private lazy var datePickerView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.addSubview(datePicker)
        view.addSubview(doneButton())
        return view
    }()
   
    @IBAction func changeDate(_ sender: Any) {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(datePickerView)
    }
    
    @objc func updateDate() {
        dateLabel.text = DateFormatter.defaultFormatter.string(from: datePicker.date)
        datePickerView.removeFromSuperview()
        navigationController?.isNavigationBarHidden = false
    }
}

private extension EditTaskViewController {
    
    func setUpNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = viewModel.navigationTitle
        navigationItem.rightBarButtonItem = rightNavigationItem()
    }
    
    func showTaskDetails() {
        guard let task = viewModel.task else { return }
        titleTextView.text = task.title
        priorityControl.selectedSegmentIndex = task.priority.rawValue
        dateLabel.text = DateFormatter.defaultFormatter.string(from: task.date)
        descriptionTextView.text = task.description
    }
    
    func setUpAppearence() {
        showTaskDetails()
        titleTextView.layer.cornerRadius = 2.0
        titleTextView.layer.borderColor = UIColor.lightGray.cgColor
        titleTextView.layer.borderWidth = 2.0
        
        descriptionTextView.layer.cornerRadius = 2.0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 2.0
    }
    
    func rightNavigationItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateTask))
    }
    
    func doneButton() -> UIButton {
        let width: CGFloat = 100
        let height: CGFloat = 40
        
        let size = view.frame.size
        let y = size.height - height * 2
        let x = size.width / 2 - width / 2
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let button = UIButton(frame: frame)

        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(updateDate), for: .touchUpInside)
        button.layer.backgroundColor = UIColor.lightGray.cgColor
        return button
    }
    
    @objc func updateTask() {
        let title = titleTextView.text ?? "Title"
        let textDate = dateLabel.text ?? ""
        let index = priorityControl.selectedSegmentIndex
        let textPriority = priorityControl.titleForSegment(at: index) ?? ""
        
        viewModel.done(title: title, date: textDate, priority: textPriority) {
            self.coordinator?.navigationController.popViewController(animated: true)
        }
    }
}
