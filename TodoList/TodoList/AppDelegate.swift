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
        DDLog.add(DDOSLogger.sharedInstance)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let modelData = TestModel()
        let itemsController = ItemsViewController(modelData)
        
        let navigationController = UINavigationController(rootViewController: itemsController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

