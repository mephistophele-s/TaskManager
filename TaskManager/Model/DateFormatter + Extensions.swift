//
//  DateFormatter + Extensions.swift
//  TaskManager
//
//  Created by Anastasia on 14.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    static var defaultFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }
}
