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
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        DDLog.add(DDOSLogger.sharedInstance)
        
 
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let itemsController = ItemsViewController()
     
//        let navigationController = UINavigationController(rootViewController: itemsController)
        window?.rootViewController = itemsController
        window?.makeKeyAndVisible()
        
        return true
    }
}

