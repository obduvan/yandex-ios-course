//
//  FileCache.swift
//  TodoList
//
//  Created by Артем Яблоковский on 12.11.2021.
//

import Foundation
import CocoaLumberjack


class FileCache {
    private(set) var todoItems: [String: TodoItem]
    
    init() {
        self.todoItems = [:]
    }
    
    func addItem(todoItem: TodoItem) {
        self.todoItems[todoItem.id] = todoItem
    }
    
    func deleteItem(id: String) {
        self.todoItems.removeValue(forKey: id)
    }
    
    private func getItemFilePath(dirURL: URL) -> String {
        return dirURL.appendingPathComponent(Date().description).path
    }
    
    private var cachePath: URL? {
        get {
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            guard let pathCache = path.first else {
                DDLogError("Failed to find cache path.")
                return nil
            }
            
            let folder = "TodoItems"
            return pathCache.appendingPathComponent(folder)
        }
    }
    
    func saveItems() {
        do {
            DDLogDebug("Started to save items.")
            
            guard let dirURL = self.cachePath else { return }
            
            var isDir: ObjCBool = true
            if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir){
                 try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
            }
            let itemsData = try JSONSerialization.data(withJSONObject: self.todoItems.values.map({$0.json}), options: [])
            let fileManager = FileManager.default
            
            fileManager.createFile(atPath: getItemFilePath(dirURL: dirURL), contents: itemsData, attributes: nil)
            
            DDLogDebug("Items was successfully saved.")
        }
        catch {
            DDLogError("Failed to save TodoItems: \(error.localizedDescription)")
        }
    }
    
    func loadItems() {
        do {
            DDLogDebug("Started to load items.")

            guard let cachePath = self.cachePath else { return }
            let files = try FileManager.default.contentsOfDirectory(atPath: cachePath.path)
            
            for file in files {
                guard let dataItems = try? Data(contentsOf: cachePath.appendingPathComponent(file)) else { continue }
                guard let dictItems = try? JSONSerialization.jsonObject(with: dataItems, options: []) as? [Any] else { continue }
                for item in dictItems {
                    if let todoItem = TodoItem.parse(json: item){
                        self.addItem(todoItem: todoItem)
                    }
                }
            }
            DDLogDebug("Items was successfully loaded.")
        }
        catch {
            DDLogError("Failed to load items: \(error.localizedDescription)")
        }
    }
}
