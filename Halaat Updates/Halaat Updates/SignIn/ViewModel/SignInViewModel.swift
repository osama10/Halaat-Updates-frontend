//
//  SignInViewModel.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 23/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//



import Foundation
import ObjectMapper
import RxSwift

protocol SignInViewModel {
    
    var webManager : WebManager!{get set}
    var user : UserModel?{get}
    
    func didReturnPressed()
    func getHalatFeedsViewModel(user : UserModel)->HalatFeedsViewModel
    func getSignupViewModel()->SignupViewModel
    
    var email : Variable<String>{get set}
    var password : Variable<String>{get set}
    var signinButtonTap : PublishSubject<Void>{get set}
    var showLoader : Variable<Bool>{get set}
    var closeKeyboard : Variable<Bool>{get set}
    var showAlert : Variable<(String,String)>{get set}
    var loginToMainView : Variable<Bool>{get set}
}


struct SignInViewModelImp : SignInViewModel{
    var returnPressed : (()->())?
    
    var webManager  : WebManager!
    var user : UserModel?
    
    var email : Variable<String> = Variable<String>("")
    var password : Variable<String> = Variable<String>("")
    var signinButtonTap: PublishSubject<Void> = PublishSubject<Void>()
    var showLoader: Variable<Bool> = Variable<Bool>(false)
    var closeKeyboard: Variable<Bool> = Variable<Bool>(false)
    var showAlert: Variable<(String,String)> = Variable<(String,String)>(("" , ""))
    var loginToMainView: Variable<Bool> = Variable<Bool>(false)
    
    var disposeBag = DisposeBag()
    
    init(webManager : WebManager) {
        self.webManager = webManager
        subscribeObservables()
    }
    
    private func subscribeObservables(){
        signinButtonTap
            .subscribe { _ in
                var this = self
                this.didTapOnLogin()
            }
            .disposed(by: disposeBag)
   
    }
    
    
    private mutating func didTapOnLogin(){
        
        if(Utils.isTextFieldEmpty(textArray: [self.email.value , self.password.value])){
            let title = "Textfields emtpy"
            let message = "Please fill all the Textfields"
            showAlert.value = (title , message)
        }else if(!Utils.isValidEmail(testStr: self.email.value)){
            let title = "InValid Email"
            let message = "Please enter a valid email"
            showAlert.value = (title , message)
        }else{
            let credetials = SignInCred(email: self.email.value, password: self.password.value)
            login(credentials: credetials)
        }
    }
    
    func didReturnPressed(){
        closeKeyboard.value = true
    }
    
    func getHalatFeedsViewModel(user : UserModel) -> HalatFeedsViewModel {
        return HalatFeedsViewModelImp(user: user , webManager : webManager)
    }
    
    func getSignupViewModel()->SignupViewModel{
        return SignupViewModelImp(webManager: webManager)
    }
    
    fileprivate mutating func login(credentials : SignInCred){
        
        self.showLoader.value = true
        var this = self
        webManager.signIn(credential: credentials) {  (response) in
            
            this.showLoader.value = false
            
            if(response.responseCode == 0){
                let title = "Login Failed"
                let message = response.response["response"] as? String ?? "There is something wrong. Please try later."
                this.showAlert.value = (title , message)
                
            }else{
                let responseCode = (response.response["response"] as! [String : AnyObject])["statusCode"] as! Int
                if(responseCode == 201){
                    let responseBody = (response.response["response"] as! [String : AnyObject])["responseBody"] as! [String : AnyObject]
                    
                    let userDict = responseBody["Data"] as! [String  : AnyObject]
                    
                    guard let user = Mapper<UserModel>().map(JSON: userDict) else {
                        let title = "Login Failed"
                        let message =  "There is something wrong. Please try later."
                        this.showAlert.value = (title , message)
                        return
                    }
                    
                    this.user = user
                    this.loginToMainView.value = true
                }
                else{
                    let responseBody = (response.response["response"] as! [String : AnyObject])["responseBody"] as! [String : AnyObject]
                    
                    let title = "Login Failed"
                    let message =  responseBody["Data"] as! String

                    this.showAlert.value = (title , message)
                }
            }
        }
    }
}

