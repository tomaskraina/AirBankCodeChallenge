//
//  LoadingPresentable.swift
//  AirBank
//
//  Created by Tom Kraina on 22/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

protocol LoadingPresentable: NSObjectProtocol {
    var loadingView: LoadingView? { get set }
    func showLoading(animated: Bool)
    func hideLoading()
}


private var LoadingViewKey = 0


/// Wrapper for objects in order to deal with not autozeroing references
/// More info: https://stackoverflow.com/a/27035233/1161723
class WeakObjectContainer<T: AnyObject> {
    weak private(set) var object: T?
    
    init(_ object: T?) {
        self.object = object
    }
}


extension LoadingPresentable where Self: UIViewController {
    
    var loadingView: LoadingView? {
        get {
            return (objc_getAssociatedObject(self, &LoadingViewKey) as? WeakObjectContainer<LoadingView>)?.object
        }
        set {
            objc_setAssociatedObject(self, &LoadingViewKey, WeakObjectContainer(newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showLoading(animated: Bool = true) {
        
        guard self.loadingView == nil else { return }
        
        let loadingView = LoadingView()
        
        if let tableView = view as? UITableView {
            tableView.backgroundView = loadingView
            
        } else if let collectionView = view as? UICollectionView {
            collectionView.backgroundView = loadingView
            
        } else {
            view.addSubview(loadingView)
            view.addFullsizeConstraintsForSubview(loadingView)
        }
        
        self.loadingView = loadingView
        
        
        guard animated else { return }
        
        loadingView.alpha = 0
        UIView.animate(withDuration: 0.33) {
            loadingView.alpha = 1
        }
    }
    
    func hideLoading() {
        loadingView?.removeFromSuperview() // superview is nil in case of UITableView???
        if (view as? UITableView)?.backgroundView == loadingView {
            (view as? UITableView)?.backgroundView = nil
        }
        
        if (view as? UICollectionView)?.backgroundView == loadingView {
            (view as? UICollectionView)?.backgroundView = nil
        }
        
        loadingView = nil
    }
}
