//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by Артем Яблоковский on 13.12.2021.
//

import UIKit
import Foundation

protocol DoneTaskDelegate: AnyObject {
    func setDoneTask(_ rowIndex: Int)
}

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var colorView: UIImageView!
    
    
    func setViews(_ todoItem: TodoItem) {
        descriptionLabel.text = todoItem.text
        
        if let color = todoItem.color {
            colorView.backgroundColor = color
        }
        else {
            colorView.backgroundColor = .white
        }
        
        if let deadline = todoItem.deadLine {
            timeLabel.isHidden = false
            timeLabel.text = formatDate(deadline)
        }
        else {
            timeLabel.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM YYYY"
        return dateFormatter.string(from: date)
    }
}
