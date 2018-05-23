//
//  WebManager.swift
//  Halaat Updates
//
//  Created by inVenD on 23/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireManager{
    func makeRequest(_ url: String , method: HTTPMethod = .post, params: [String : AnyObject]? = nil, headers: [String : String]? = nil,  success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void){
        
        
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                if let resJson = responseObject.result.value as? NSDictionary{
                    success(resJson)
                }else if let resJsonArray = responseObject.result.value as? NSArray{
                    success(resJsonArray)
                }else if let resInt = responseObject.result.value as? Int{
                    success(resInt)
                }
            }else if responseObject.result.isFailure {
                let error: Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
}
