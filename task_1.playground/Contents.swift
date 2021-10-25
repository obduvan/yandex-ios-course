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


public enum Importance: String{
    case notImportant
    case regular
    case important
}

extension UIColor {
    public convenience init?(hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        let countHex = hexFormatted.count
        var r,g,b: CGFloat
        var a: CGFloat = 1.0
        var rgbValue: UInt64 = 0
        
        guard Scanner(string: hexFormatted).scanHexInt64(&rgbValue) else { return nil }
        
        if (countHex == 6){
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
        }
        else if (countHex == 8){
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgbValue & 0x000000FF) / 255.0
        }
        else{
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func getHex() -> String {
        var r,g,b,a: CGFloat
        r = 0
        g = 0
        b = 0
        a = 1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba: Int = (Int)(r*255.0) << 24 | (Int)(g * 255.0) << 16 | (Int)(b*255.0) << 8 | (Int)(a*255.0)
        return String(format:"#%08X", rgba)
    }
}



extension TodoItem {
    var json: Any {
        get{
            var dict: [String: Any] = ["id": id, "text": text]
            if importance != .regular {
                dict["importance"] = importance.rawValue
            }
                        
            if let deadLine = self.deadLine {
                dict["deadLine"] = deadLine.timeIntervalSince1970
            }
            if let hexcolor = color?.getHex() {
                dict["color"] = hexcolor
            }
                        
            return dict
        }
    }
    
    static func parse(json: Any) -> TodoItem? {
        if let dict = json as? [String: Any] {
            guard let id = (dict["id"] as? String) else { return nil }
            guard let text = (dict["text"] as? String) else { return nil }
                
            let importance = Importance(rawValue: dict["importance"] as? String ?? Importance.regular.rawValue) ?? .regular
            var deadLine: Date? = nil
            var color: UIColor? = nil
            
            if let deadLineDouble = dict["deadLine"] as? Double {
                deadLine = Date(timeIntervalSince1970: deadLineDouble)
            }
            
            if let colorStr = (dict["color"] as? String) {
                color = UIColor(hex: colorStr)
            }
            
            return TodoItem(id: id, text: text, importance: importance, deadLine: deadLine, color: color)
            
        }
        else {
            print("Wrong argument type.")
            return nil
        }
    }
}


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
            guard let pathCache = path.first else { return nil }
            let folder = "TodoItems"
            return pathCache.appendingPathComponent(folder)
        }
    }
    
    func saveItems() {
        do {
            guard let dirURL = self.cachePath else { return }
            
            var isDir: ObjCBool = true
            if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir){
                guard let _ = try? FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil) else {
                    print("Failed to create 'TodoItems' folder in Caches directory.")
                    return
                }
            }
            let itemsData = try JSONSerialization.data(withJSONObject: self.todoItems.values.map({$0.json}), options: [])
            let fileManager = FileManager.default
            
            fileManager.createFile(atPath: getItemFilePath(dirURL: dirURL), contents: itemsData, attributes: nil)
        }
        catch {
            print("Failed to save TodoItems.")
        }
    }
    
    func loadItems() {
        do {
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
        }
        catch {
            print("Failed to load Items.")
        }
    }
}



//Путь до кэша:
//let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

//Пример тестирования:

//let t1 = TodoItem(id: "1", text: "someText", importance: Importance.notImportant, deadLine: Date(timeIntervalSinceNow: 322))
//let t2 = TodoItem(id: "2", text: "someTextsadas", importance: Importance.regular, deadLine: Date(timeIntervalSince1970: 31312321321.0), color: UIColor.black)
//
//var fileCache = FileCache()
//fileCache.addItem(todoItem: t1)
//fileCache.addItem(todoItem: t2)
//fileCache.saveItems()
//fileCache.deleteItem(id: "1")
//fileCache.deleteItem(id: "2")
//fileCache.loadItems()
//fileCache.todoItems.forEach({print($0)})
