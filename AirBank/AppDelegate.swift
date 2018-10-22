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

    var mainFlowCoordinator: MainFlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let window = window else {
            fatalError("AppDelegate is missing UIWindow")
        }
        
        struct AppDependencies: MainFlowCoordinator.Dependencies {
            
            let accountCurrencyCode: CurrencyCode
            
            var apiClient: ApiClient {
                return ApiClient(networking: Networking.shared)
            }
            
            var currencyFormatter: NumberFormatter {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.currencyCode = accountCurrencyCode.rawValue
                return formatter
            }
        }
        
        let appDependencies = AppDependencies(accountCurrencyCode: CurrencyCode(rawValue: "CZK"))
        let flowCoordinator = MainFlowCoordinator(window: window, dependencies: appDependencies)
        flowCoordinator.loadRootViewController()
        mainFlowCoordinator = flowCoordinator
        
        return true
    }

}

