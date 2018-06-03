//
//  Protocols.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 25/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView : class {  static var reuseIdentifier : String {get} }

extension ReusableView where Self : UITableViewCell {
    static var reuseIdentifier : String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
protocol AlertsPresentable : class {}

extension AlertsPresentable where Self : UIViewController {
    
    func showAlert(with title: String? = nil , and message: String? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showPermissionAlert(title : String , message : String , actionButtonTitle : String , completion :  @escaping () -> Void){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: actionButtonTitle , style: .default, handler: {
            alert -> Void in
            
            completion()
        })
        
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
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


