//
//  Task2.swift
//  TodoList
//
//  Created by Артем Яблоковский on 13.11.2021.
//

import Foundation
import UIKit

class Task2 {
    var memoryLeak2 : MemoryLeak2?
    var memoryLeak1 : MemoryLeak1?
    
    func star_2_memory() {
        self.memoryLeak2 = MemoryLeak2()
        self.memoryLeak1 = MemoryLeak1(obj: self.memoryLeak2)
        self.memoryLeak2?.memoryLeak1 = self.memoryLeak1
        
        self.memoryLeak1 = nil
        self.memoryLeak2 = nil
    }
    
    func star_2_cpu(n: Int) {
        print((1...n).map(Double.init).reduce(1.0, *))
    }
    
    func star_1() {
        let fileCache = FileCache()
        let items = createTodoItems()
        self.saveAndRemoveItems(items:items, fileCache: fileCache)
        
        fileCache.loadItems()
        //        fileCache.todoItems.forEach({print($0)})
    }
    
    private func createTodoItems() -> [TodoItem] {
        var items: [TodoItem] = []
        (0...10).forEach { i in
            items.append(TodoItem(id: i.description, text: "someText", importance: Importance.notImportant, deadLine: Date(timeIntervalSinceNow: 322), color: UIColor.black))
        }
        return items
    }
    private func saveAndRemoveItems(items:[TodoItem], fileCache: FileCache) {
        items.forEach { (item) in
            fileCache.addItem(todoItem: item)
        }
        fileCache.saveItems()
        
        items.forEach { (item) in
            fileCache.deleteItem(id: item.id)
        }
    }
}
