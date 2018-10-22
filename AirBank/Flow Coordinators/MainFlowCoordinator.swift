//
//  MainFlowCoordinator.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

class MainFlowCoordinator {
    
    typealias Dependencies = HasApiClient & HasCurrencyFormatter
    
    let window: UIWindow
    
    let dependencies: Dependencies
    
    var navigationController: UINavigationController?
    
    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func loadRootViewController() {

        let viewController = StoryboardScene.List.initialScene.instantiate()
        
        let viewModel = ListViewModel(dependencies: dependencies)
        viewController.viewModel = viewModel
        viewController.delegate = self
        
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showDetail(transaction: Transaction) {
        
        let viewController = StoryboardScene.Detail.initialScene.instantiate()
        let viewModel = DetailViewModel(transaction: transaction, dependencies: dependencies)
        viewController.viewModel = viewModel

        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - MainFlowCoordinator: ListViewControllerDelegate
extension MainFlowCoordinator: ListViewControllerDelegate {
    func list(viewController: ListViewController, didSelect item: Transaction) {
        showDetail(transaction: item)
    }
}
