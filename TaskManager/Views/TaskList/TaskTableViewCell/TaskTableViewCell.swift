//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Anastasia on 10/5/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var task: Task? {
        didSet {
            guard let task = task else { return }
            titleLabel.text = task.title
            
            dateLabel.text = "Due to: \(DateFormatter.defaultFormatter.string(from: task.date))"
            priorityLabel.text = "\(task.priority)"
            priorityLabel.textColor = task.priority.color
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
