//
//  WebManager.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 23/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation

protocol WebManager : class{
    
    func signIn(credential : SignInCred ,  completion: @escaping resultCallback)
    func signup(userData : SignupDTO ,  completion: @escaping resultCallback)
    func getAllFeeds(completion: @escaping (_ result: Response) -> Void)
    func postFeed(postData : PostModel , completion: @escaping resultCallback)
}


class WebManagerImp : WebManager{
    
    let alamofireManager = AlamofireManager()
    let firebaseManager = FirebaseManager()
    
    func signIn(credential: SignInCred, completion: @escaping resultCallback) {
        
        let params = ["email" : credential.email, "password" : credential.password] as [String : AnyObject]
        
        let request = Request(url: WebRoutes.baseUrl + WebRoutes.signin, httpMethod: .post, params: params  , headers: nil)
        
        makeRequest(request: request, logTextSuccess: "Signin Success", logTextFailure: "Signin Error", completion: completion)
    }
    
    func signup(userData: SignupDTO, completion: @escaping resultCallback) {
        let params  = ["name" : userData.name , "password" : userData.password , "email" : userData.email , "occupation" : userData.occupation] as [String : AnyObject]
        
        let request = Request(url: WebRoutes.baseUrl + WebRoutes.signup, httpMethod: .post, params: params  , headers: nil)
        
        makeRequest(request: request , logTextSuccess: "Signup Success", logTextFailure: "Signup Failure", completion: completion)
    }
    
    func getAllFeeds(completion: @escaping resultCallback) {
        
        let request = Request(url: WebRoutes.baseUrl + WebRoutes.getAllUpdates , httpMethod: .get, params: nil  , headers: ["Content-Type": "application/json"])
        
        makeRequest(request: request, logTextSuccess: "Get All feeds Success", logTextFailure: "Get All Fields Error", completion: completion)
    }
    
    func postFeed(postData: PostModel, completion: @escaping resultCallback) {
        self.saveFileToStorage(imageUrl: postData.image, imageData: postData.imageData) { (url, error) in
            self.postFeedResponseHandler(url: url, error: error, postData: postData , completion:  completion)
        }
    }
    
    private func postFeedResponseHandler(url : String? , error : Error? , postData : PostModel , completion: @escaping resultCallback){
        if error != nil && url != nil{
            return  completion(Response(responseCode: 0, response: ["response" : error!.localizedDescription as AnyObject]))
        }else {
           self.sentFeedToServer(with: url!, postData: postData, completion: completion)
        }
    }
 
    private func sentFeedToServer(with url : String , postData : PostModel ,completion: @escaping resultCallback){
        let params  = ["title" : postData.title , "description" : postData.description , "image" : url , "date" : postData.date , "userId" : postData.userId] as [String : AnyObject]
        
        let request = Request(url: WebRoutes.baseUrl + WebRoutes.postFeed, httpMethod: .post, params: params  , headers: nil)
        
        makeRequest(request: request, logTextSuccess: "Post Feed Success", logTextFailure: "Post Feed Error") { (response) in
            completion(response)
        }
    }
    private func saveFileToStorage(imageUrl : String , imageData : Data , completion: @escaping stringErrorCallback){
        let refrence = firebaseManager.getFileStorageRefrence(storageURL: imageUrl)
        firebaseManager.putDataToServer(refrence: refrence, fileData: imageData, metadata: nil, completion: completion)
    }
    
    private func makeRequest(request : Request , logTextSuccess : String , logTextFailure : String ,  completion: @escaping resultCallback){
        alamofireManager.makeRequest(request: request ,  success: { (data) in
            print("\(logTextSuccess) : \(data)")
            
            completion(Response(responseCode: 1, response: ["response" : data  as AnyObject]))
            
        }) { (error) in
            print("\(logTextFailure) : \(error)")
            
            completion(Response(responseCode: 0, response: ["response" : error.localizedDescription as AnyObject]))
            
        }
    }
}
