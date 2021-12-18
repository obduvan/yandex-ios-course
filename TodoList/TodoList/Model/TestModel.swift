//
//  TestData.swift
//  TodoList
//
//  Created by Артем Яблоковский on 13.12.2021.
//

import Foundation
import UIKit


/*
 Тестовая модель данных
 */

class TestModel {
    
    private(set) var doneTasks: [TodoItem] = []
    private(set) var tasks: [TodoItem] = []
    
//    init() {
//        (0...10).forEach { i in
//            tasks.append(TodoItem(id: i.description, text: String(i), importance: Importance.important, deadLine: Date(timeIntervalSinceNow: 312312), color: UIColor.systemOrange))
//        }
//    }
    
    func addTasks(_ todoItem: TodoItem){
        tasks.insert(todoItem, at: 0)
    }
    
    func addDoneTasks(_ todoItem: TodoItem){
        doneTasks.insert(todoItem, at: 0)
    }
    
    func deleteTasks(_ index: Int) {
        tasks.remove(at: index)
    }
    
    func deleteDoneTasks(_ index: Int) {
        doneTasks.remove(at: index)
    }
    
    func transferDoneTask(_ index: Int) {
        let todoItem = tasks.remove(at: index)
        doneTasks.insert(todoItem, at: 0)
    }
    
    func returnTask(_ index: Int) {
        let todoItem = doneTasks.remove(at: index)
        tasks.insert(todoItem, at: 0)
    }
    
    func updateDoneTasks(_ index: Int, _ todoItem: TodoItem){
        doneTasks[index] = todoItem
    }
    func updateTasks(_ index: Int, _ todoItem: TodoItem){
        tasks[index] = todoItem
    }
}
