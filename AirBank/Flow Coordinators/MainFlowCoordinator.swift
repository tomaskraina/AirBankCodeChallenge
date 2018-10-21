//
//  MainFlowCoordinator.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

class MainFlowCoordinator {
    
    let window: UIWindow
    
    var navigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func loadRootViewController() {

        let viewController = StoryboardScene.List.initialScene.instantiate()
        
        // TODO: dependency injection & config
        
        let apiClient = ApiClient(networking: Networking.shared)
        let viewModel = ListViewModel(apiClient: apiClient)
        viewController.viewModel = viewModel
        
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showDetail(transactionId: Identifier<Transaction>) {
        
        let viewController = StoryboardScene.Detail.initialScene.instantiate()
        
        // TODO: dependency injection & config

        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
