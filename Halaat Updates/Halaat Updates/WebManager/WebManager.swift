//
//  WebManager.swift
//  Halaat Updates
//
//  Created by inVenD on 23/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation

protocol WebManager : class{
    func signIn(credential : SignInCred ,  completion: @escaping (_ result: Response) -> Void)
    func getAllFeeds(completion: @escaping (_ result: Response) -> Void)
    
}


class WebManagerImp : WebManager{
    let alamofireManager = AlamofireManager()
    
    func signIn(credential: SignInCred, completion: @escaping (Response) -> Void) {
        let params = ["email" : credential.email,
                      "password" : credential.password
                  ]
        alamofireManager.makeRequest(WebRoutes.baseUrl + WebRoutes.signin , method: .post, params: params as [String : AnyObject], headers: nil, success: { (data) in
            print("login data : \(data)")
            completion(Response(responseCode: 1, response: ["response" : data  as AnyObject]))
            
        }) { (error) in
            print("login error \(error.localizedDescription)")
            completion(Response(responseCode: 0, response: ["response" : error.localizedDescription as AnyObject]))
            
        }
    }
    
    func getAllFeeds(completion: @escaping (Response) -> Void) {
        alamofireManager.makeRequest(WebRoutes.baseUrl + WebRoutes.getAllUpdates , method: .get , headers: ["Content-Type": "application/json"] ,  success: { (data) in
            print("get all feeds : \(data)")
            completion(Response(responseCode: 1, response: ["response" : data  as AnyObject]))

        }) { (error) in
            print("get all feeds error : \(error)")
            completion(Response(responseCode: 0, response: ["response" : error.localizedDescription as AnyObject]))

        }
    }
}
