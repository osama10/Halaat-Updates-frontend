//
//  SignInViewModel.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 23/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//



import Foundation
import ObjectMapper

protocol SignInViewModel {
    
    var showAlert : ((_ title : String , _ message : String )->())?{get set}
    var success : (()->())?{get set}
    var showLoader : (()->())?{get set}
    var hideLoader : (()->())?{get set}
    var returnPressed : (()->())?{get set}
    
    var webManager : WebManager!{get set}
    var user : UserModel?{get}
    
    func didTapOnLogin(email : String , password : String)
    func didReturnPressed()
    func getHalatFeedsViewModel(user : UserModel)->HalatFeedsViewModel
    
}


class SignInViewModelImp : SignInViewModel{
    
    var showAlert : ((_ title : String , _ message : String )->())?
    var success : (()->())?
    var showLoader : (()->())?
    var hideLoader : (()->())?
    var returnPressed : (()->())?
    
    var webManager  : WebManager!
    var user : UserModel?
    
    init(webManager : WebManager) {
        self.webManager = webManager
    }
    
    func didTapOnLogin(email : String , password : String){
        if(Utils.isTextFieldEmpty(textArray: [email , password])){
            showAlert?("Textfields emtpy" , "Please fill all the Textfields")
        }else if(!Utils.isValidEmail(testStr: email)){
            showAlert?("InValid Email" , "Please enter a valid email")
        }else{
            let credetials = SignInCred(email: email, password: password)
            login(credentials: credetials)
        }
    }
    
    func didReturnPressed(){
        returnPressed?()
    }
    
    func getHalatFeedsViewModel(user : UserModel) -> HalatFeedsViewModel {
        return HalatFeedsViewModelImp(user: user , webManager : webManager)
    }
    
    fileprivate func login(credentials : SignInCred){
        
        showLoader?()
        
        webManager.signIn(credential: credentials) { [weak self] (response) in
            guard let this = self else{return}
            this.hideLoader?()
            
            if(response.responseCode == 0){
                this.showAlert?("Login Failed" , response.response["response"] as? String ?? "There is something wrong. Please try later.")
            }else{
                let responseBody = (response.response["response"] as! [String : AnyObject])["responseBody"] as! [String : AnyObject]
                let userDict = responseBody["Data"] as! [String  : AnyObject]
                guard let user = Mapper<UserModel>().map(JSON: userDict) else {
                     this.showAlert?("Login Failed" , "There is something wrong. Please try later.")
                    return
                }
                this.user = user
                this.success?()
            }
            
        }
    }
}

