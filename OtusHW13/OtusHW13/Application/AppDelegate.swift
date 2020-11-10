//
//  AppDelegate.swift
//  OtusHW13
//
//  Created by Vladyslav Pokryshka on 29.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let sharedDefaults = UserDefaults(suiteName: "group.otusvp.shared"),
           let sharedArray = sharedDefaults.stringArray(forKey: "sharedStringsArray") ?? [String](),
           sharedArray.count > 0 {
            openMainController(text: sharedArray[0])
        }
                
        return true
        
    }
    
    private func openMainController(text: String) {
        print("Open main controller for newly shared text: \(text)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
        self.window?.rootViewController = tabBarController
        
    }

}


