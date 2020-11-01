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
        
        if let ud = UserDefaults(suiteName: "group.otusvp.shared"),
           let shareText = ud.object(forKey: "sharedText") as? String {
                openMainController(text: shareText)
        }
        
        return true
        
    }
    
    private func openMainController(text: String) {
        print("Open main controller")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "TableViewController")
        
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController

        navigationController.viewControllers = [mainViewController]
        self.window?.rootViewController = navigationController
        
    }

}


