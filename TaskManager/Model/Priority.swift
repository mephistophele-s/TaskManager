//
//  Priority.swift
//  TaskManager
//
//  Created by Anastasia on 10/5/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import UIKit

enum Priority: Int, CaseIterable {
    
    case low, medium, high
    
    var color: UIColor {
        switch self {
        case .low:
            return UIColor(red: 0.004, green: 0.443, blue: 0.0, alpha: 1.0)
        case .medium:
            return UIColor(red: 1.0, green: 0.576, blue: 0.0, alpha: 1.0)
        case .high:
            return UIColor(red: 0.710, green: 0.092, blue: 0.0, alpha: 1.0)
        }
    }
    
    var description: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
    
    static func from(string: String) -> Priority? {
        return Priority.allCases.first(where: { $0.description == string })
    }
}

extension Priority: Comparable {
    
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

