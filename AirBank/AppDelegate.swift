//
//  AppDelegate.swift
//  AirBank
//
//  Created by Tom Kraina on 19/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let window = window else {
            fatalError("AppDelegate is missing UIWindow")
        }
        
        let flowCoordinator = MainFlowCoordinator(window: window)
        flowCoordinator.loadRootViewController()
        
        return true
    }

}

