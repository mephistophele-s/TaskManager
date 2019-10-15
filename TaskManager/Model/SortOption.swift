//
//  SortOption.swift
//  TaskManager
//
//  Created by Anastasia on 10/6/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import UIKit

let defaultSorting: (option: SortOption, order: SortOrder) = (SortOption.title, SortOrder.asc)

enum SortOption: Int, CaseIterable {
    
    case title, date, priority
    
    static func option(for index: Int) -> SortOption? {
        var sortOption: SortOption?
        SortOption.allCases.forEach { option in
            if index == option.rawValue {
                sortOption = option
            }
        }
        return sortOption
    }
    
    var description: String {
        switch self {
        case .title:
            return "title"
        case .date:
            return "dueBy"
        case .priority:
            return "priority"
        }
    }
    
}

enum SortOrder {
    
    case asc, desc
    
    var image: UIImage? {
        switch self {
        case .asc:
            return UIImage(named: "sortUp")
        case .desc:
            return UIImage(named: "sortDown")
        }
    }
}
