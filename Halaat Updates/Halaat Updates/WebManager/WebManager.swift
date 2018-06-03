//
//  WebManager.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 23/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation

protocol WebManager : class{
   
    func signIn(credential : SignInCred ,  completion: @escaping (_ result: Response) -> Void)
    func signup(userData : SignupDTO ,  completion: @escaping (_ result: Response) -> Void)
    func getAllFeeds(completion: @escaping (_ result: Response) -> Void)
    
}


class WebManagerImp : WebManager{
    
    let alamofireManager = AlamofireManager()
    
    func signIn(credential: SignInCred, completion: @escaping (Response) -> Void) {
        
        let params = ["email" : credential.email, "password" : credential.password] as [String : AnyObject]
        
        let request = Request(url: WebRoutes.baseUrl + WebRoutes.signin, httpMethod: .post, params: params  , headers: nil)
        
        makeRequest(request: request, logTextSuccess: "Signin Success", logTextFailure: "Signin Error", completion: completion)
    }
    
    func signup(userData: SignupDTO, completion: @escaping (Response) -> Void) {
        let params  = ["name" : userData.name , "password" : userData.password , "email" : userData.email , "occupation" : userData.occupation] as [String : AnyObject]
        
        let request = Request(url: WebRoutes.baseUrl + WebRoutes.signup, httpMethod: .post, params: params  , headers: nil)
        
        makeRequest(request: request , logTextSuccess: "Signup Success", logTextFailure: "Signup Failure", completion: completion)
    }
    
    func getAllFeeds(completion: @escaping (Response) -> Void) {
        
        let request = Request(url: WebRoutes.baseUrl + WebRoutes.getAllUpdates , httpMethod: .get, params: nil  , headers: ["Content-Type": "application/json"])
        
        makeRequest(request: request, logTextSuccess: "Get All feeds Success", logTextFailure: "Get All Fields Error", completion: completion)
    }
    
    private func makeRequest(request : Request , logTextSuccess : String , logTextFailure : String ,  completion: @escaping (Response) -> Void){
        alamofireManager.makeRequest(request: request ,  success: { (data) in
            print("\(logTextSuccess) : \(data)")
            
            completion(Response(responseCode: 1, response: ["response" : data  as AnyObject]))
            
        }) { (error) in
            print("\(logTextFailure) : \(error)")
            
            completion(Response(responseCode: 0, response: ["response" : error.localizedDescription as AnyObject]))
            
        }
    }
}
