//
//  TodoItem.swift
//  TodoList
//
//  Created by Артем Яблоковский on 12.11.2021.
//

import Foundation
import UIKit


struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadLine: Date?
    let color: UIColor?
    public init(id: String = UUID().uuidString,
                text: String,
                importance: Importance,
                deadLine: Date? = nil,
                color: UIColor? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadLine = deadLine
        self.color = color
    }
}
