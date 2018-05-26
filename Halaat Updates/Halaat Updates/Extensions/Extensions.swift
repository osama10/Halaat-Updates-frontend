//
//  Extensions.swift
//  Halaat Updates
//
//  Created by inVenD on 23/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//


import Foundation
import UIKit

extension UIView  {
    func addCornerRadius(value : CGFloat){
        self.layer.cornerRadius = value
    }
    
    func loadNib<T : UIView>() -> T where T : NibLoadableView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! T
    }
    
    func addShadow( color : UIColor , opacity : Float , shadowRadius : CGFloat ){
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        
    }
}


extension UICollectionView{
    var collectionViewFlowLayout: UICollectionViewFlowLayout{
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
}

extension UIViewController{
    
    func showAlertControllerWithOkTitle(title: String? = nil,message: String? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func alertTextBox(title : String , message : String , actionButtonTitle : String , completion :  @escaping () -> Void){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: actionButtonTitle , style: .default, handler: {
            alert -> Void in
            
            completion()
        })
        
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension Int{
    
    var toString: String{
        return String(self)
    }
}

extension Double{
    var toString: String{
        return String(self)
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    var toDouble : Double {
        return Double(self) ?? 0.0
    }
}


extension Collection {
    
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
    
}


extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension Notification.Name {
    
    static let notificataionForFriendList = Notification.Name("notificataionForFriendList")
    static let notificataionForLocation = Notification.Name("notificataionForLocation")
    static let notificationForFethcingLocation = Notification.Name("notificationForFethcingLocation")
    static let friendRequestCount = Notification.Name("friendRequestCount")
    static let showLoader = Notification.Name("showLoader")
    static let hideLoader = Notification.Name("hideLoader")
}

extension UIColor{
    static let primaryColor = UIColor(red: 154/255, green: 6/255, blue: 10/255, alpha: 1.0)
}

extension UITableView {
    func register<T:UITableViewCell>(_ : T.Type) where T : ReusableView , T : NibLoadableView{
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeResuseableCell<T:UITableViewCell>(for indexPath : IndexPath)->T where T : ReusableView{
       guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else{
            fatalError("Couldn't cast cell in \(T.reuseIdentifier)")
        }
        return cell
    }
}

