//
//  AppDelegate.swift
//  TodoList
//
//  Created by Артем Яблоковский on 12.11.2021.
//

import UIKit
import CocoaLumberjack

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var memoryLeak2 : MemoryLeak2?
    var memoryLeak1 : MemoryLeak1?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        метод для анализа кода на производительность и утечки памяти:
//        self.star_1()
        
        //метод симулрования проблемы учетек и производительности:
//        self.star_2()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func star_2() {
        self.memoryLeak2 = MemoryLeak2()
        self.memoryLeak1 = MemoryLeak1(obj: self.memoryLeak2)
        self.memoryLeak2?.memoryLeak1 = self.memoryLeak1
        
        self.memoryLeak1 = nil
        self.memoryLeak2 = nil
    }
    
    private func star_1() {
        let fileCache = FileCache()
        let items = createTodoItems()
        saveAndRemoveItems(items:items, fileCache: fileCache)
        
        fileCache.loadItems()
//        fileCache.todoItems.forEach({print($0)})
    }
    
    private func createTodoItems() -> [TodoItem] {
        var items: [TodoItem] = []
        (0...100).forEach { i in
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
