//
//  UIColor+Hex.swift
//  TodoList
//
//  Created by Артем Яблоковский on 12.11.2021.
//

import Foundation
import UIKit
import CocoaLumberjack


extension UIColor {
     convenience init?(hex: String) {
        DDLogDebug("Started to create UIColor from hex.")

        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        let countHex = hexFormatted.count
        var r,g,b: CGFloat
        var a: CGFloat = 1.0
        var rgbValue: UInt64 = 0
        
        guard Scanner(string: hexFormatted).scanHexInt64(&rgbValue) else {
            DDLogError("Failed to scanHexInt64.")
            return nil
        }
        
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
            DDLogError("Wrong number of charachers in the hex-record.")
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
        
        DDLogDebug("UIColor was successfully created.")
    }
    
    var hexColor: String {
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
