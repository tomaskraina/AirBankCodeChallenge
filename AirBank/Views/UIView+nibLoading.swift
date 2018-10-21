//
//  UIView+nibLoading.swift
//  AirBank
//
//  Created by Tom Kraina on 21/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

/**
 *  An UIView extension for making it easy support IBDesignable for views loaded from NIB files
 *  Inspired by: https://github.com/mbogh/NibDesignable
 *
 *  Usage:
 *      1) Create a UIView subclass (e.g. MyClass)
 *      2) Create a xib file a UIView (leave the class of the view to default)
 *      3) Set the class of the File's owner in the xib file to the UIView subclass (e.g. MyClass)
 *      4) Call `setupNib()` in the UIView subclass (e.g. MyClass) from `init(frame:)` and `init(aDecoder:)`
 */

// MARK: - extension UIView + NibLoading
public extension UIView {
    
    /**
     Should be called in init(frame:) and init(aDecoder:).
     Loads the nib and adds it as a subview.
     */
    public func setupNib() {
        let view = loadViewFromNib()
        addSubview(view)
        addFullsizeConstraintsForSubview(view)
    }
    
    /**
     Called to load the nib in setupNib().
     
     :returns: UIView instance loaded from a nib file.
     */
    public func loadViewFromNib() -> UIView {
        
        let classType = type(of: self)
        guard let nib = classType.nib() else {
            fatalError("Can't load nib name=\(classType.nibName()), bundle=\(classType.bundle().bundleIdentifier ?? "nil")")
        }
        
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    public class func bundle() -> Bundle {
        return Bundle(for: self)
    }
    
    public class func nib() -> UINib? {
        let nib = UINib(nibName: nibName(), bundle: bundle())
        return nib
    }
    
    /**
     Called in the default implementation of `nib()` and `loadViewFromNib()`.
     Default is class name. Override in subclass if needed.
     
     :returns: Name of a single view nib file.
     */
    public class func nibName() -> String {
        return String(describing: self)
    }
}
