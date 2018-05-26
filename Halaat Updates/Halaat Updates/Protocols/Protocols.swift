//
//  Protocols.swift
//  Halaat Updates
//
//  Created by inVenD on 25/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView : class {  static var reuseIdentifier : String {get} }

extension ReusableView where Self : UITableViewCell {
    static var reuseIdentifier : String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

protocol NibLoadableView : class { static var nibName : String {get} }

extension NibLoadableView where Self : UIView {
    static var nibName : String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController,
    SegueIdentifier.RawValue == String
{
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier,
                                    sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {fatalError("Invalid segue identifier \(String(describing: segue.identifier)).") }
        
        return segueIdentifier
    }
}

protocol Initializable where Self:UIViewController {
    static var storyboardName:String { get }
}

extension Initializable {
    
    private static var identifier : String {
        let name = String.init(describing: Self.self)
        return name
    }
    
    static func getInstance() -> Self {
        let storyboard = UIStoryboard(name: self.storyboardName, bundle: Bundle.main)
        let instance = storyboard.instantiateViewController(withIdentifier: identifier)
        return instance as! Self
    }
}

protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}


