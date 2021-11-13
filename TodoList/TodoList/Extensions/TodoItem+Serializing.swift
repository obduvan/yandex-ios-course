//
//  TodoItem+Serializing.swift
//  TodoList
//
//  Created by Артем Яблоковский on 12.11.2021.
//

import Foundation
import UIKit
import CocoaLumberjack

extension TodoItem {
    var json: Any {
        get {
            var dict: [String: Any] = ["id": id, "text": text]
            if importance != .regular {
                dict["importance"] = importance.rawValue
            }
                        
            if let deadLine = self.deadLine {
                dict["deadLine"] = deadLine.timeIntervalSince1970
            }
            if let hexcolor = color?.hexColor {
                dict["color"] = hexcolor
            }
            return dict
        }
    }
    
    static func parse(json: Any) -> TodoItem? {
        DDLog.add(DDOSLogger.sharedInstance)
        DDLogDebug("Started to parse json-todoItem.")

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
            
            DDLogDebug("Successfully parsed.")

            return TodoItem(id: id, text: text, importance: importance, deadLine: deadLine, color: color)
        }
        else {
            DDLogError("Failed to parse: wrong argument type.")
            return nil
        }
    }
}
