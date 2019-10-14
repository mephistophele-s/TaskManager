//
//  SortViewController.swift
//  TaskManager
//
//  Created by Anastasia on 10/6/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

protocol SortViewDelegate: class {
    
    func didChangeSortOption(option: SortOption)
}

class SortView: UIView {
    
    private let tableView = UITableView()
    private let heightForRow: CGFloat = 30
    private let cellId = "SortCell"
    private let cellCount = SortOption.allCases.count
    private var option: SortOption = .title {
        didSet {
            delegate?.didChangeSortOption(option: option)
        }
    }
    
    weak var delegate: SortViewDelegate?
    
    init(origin: CGPoint) {
        let height = heightForRow * CGFloat(cellCount)
        let frame = CGRect(x: origin.x, y: origin.y, width: 100, height: height - 1)
        super.init(frame: frame)
        setUpAppearence()
        setUpTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SortView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newSortOption = SortOption.option(for: indexPath.row), newSortOption != option else { return }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        option = newSortOption
        
        (0 ..< cellCount).forEach { index in
            if index != indexPath.row {
                let path = IndexPath(row: index, section: 0)
                let cell = tableView.cellForRow(at: path)
                cell?.accessoryType = .none
            }
        }
    }
}

extension SortView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let sortOption = SortOption.option(for: indexPath.row) {
            cell.textLabel?.text = "\(sortOption)"
            if sortOption == option {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
}

private extension SortView {
    
    func setUpTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = tableView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = tableView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = tableView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func setUpAppearence() {
//        layer.borderColor = UIColor.gray.cgColor
//        layer.borderWidth = 1.0
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
    }
}
