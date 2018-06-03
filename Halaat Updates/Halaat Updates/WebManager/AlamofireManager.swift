//
//  WebManager.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 23/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireManager{
    func makeRequest(request : Request,  success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void){
        
        
        Alamofire.request(request.url, method: request.httpMethod, parameters: request.params, encoding: JSONEncoding.default, headers: request.headers).responseJSON { (responseObject) -> Void in
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
