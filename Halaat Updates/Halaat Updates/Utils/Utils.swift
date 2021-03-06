//
//  Utils.swift
//  Gutso
//
//  Created by Osama Bin Bashir on 16/12/2017.
//  Copyright © 2017 Osama Bin Bashir. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire

class Utils {
    
    static let screenBounds = UIScreen.main.bounds
    
    class func addBorders(to view : UIView , havingWidth width : CGFloat , withColor color : UIColor , withCornerRadius radius : CGFloat){
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
        view.layer.cornerRadius = radius
    }
    
    
    class func checkIfTextFieldsAreEmpty(textFields: [UITextField])-> Bool {
        
        if (textFields.filter{$0.text == ""}.count) > 1{
            return false
        }
        return true
        
    }
    
    class func isTextFieldEmpty(textArray : [String])->Bool{
        return (textArray.filter { $0.isEmpty }.count > 0)
    }
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func createAttributedString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor) -> NSMutableAttributedString
    {
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: fullStringColor, range: NSRange(location: 0, length: fullString.characters.count))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: subStringColor, range: range)
        return attributedString
    }
    
    class func getSubViewsSize(mainView : UIView)->CGSize{
        var contentRect = CGRect.zero
        
        for view in mainView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        return contentRect.size
    }
    
    public static func openShareWidget (viewController : UIViewController , sender : UIView , textToShare : String){
        
        let objectsToShare = [textToShare , URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id1352722428?mt=8") ?? ""] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = sender
        viewController.present(activityVC, animated: true, completion: nil)
        
        
    }
    
    class func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appId)") else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    class func isNil(object : AnyObject?)->Bool{
        return (object == nil)
    }
    
    class func makeViewCircular(view : UIView , borderWidth : CGFloat , borderColor : UIColor){
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = false
        view.layer.borderColor = borderColor.cgColor
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
    }
    
  
    
    class func createCardView(view : UIView , backgroundColor : UIColor , borderColor : UIColor , borderWidth : CGFloat ){
        view.backgroundColor = backgroundColor
        view.addShadow(color: UIColor.black, opacity: 0.5, shadowRadius: 5)
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        
    }
    class func printlocalDbUrl(){
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("LOCAL DB URL : \(urls[urls.count-1] as URL)")
    }
    
    class func isConnectedToInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
}


