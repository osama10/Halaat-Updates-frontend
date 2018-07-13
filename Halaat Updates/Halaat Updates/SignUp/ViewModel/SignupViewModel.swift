//
//  SignupViewModel.swift
//  Halaat Updates
//
//  Created by inVenD on 28/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import RxSwift

protocol SignupViewModel {
    
    var userName : Variable<String>{get set}
    var email : Variable<String>{get set}
    var password : Variable<String>{get set}
    var condfirmPassword : Variable<String>{get set}
    var occupation : Variable<String>{get set}
    
    var signupButtonTap : PublishSubject<Void>{get set}
    var backButtonTap : PublishSubject<Void>{get set}
    
    var showLoader : Variable<Bool>{get set}
    var dismissViewController : PublishSubject<Void>{get set}
    var showAlert : Variable<(AlertsData)>{get set}
}

struct SignupViewModelImp : SignupViewModel {
    
    
    var showPermissionAlert: ((_ title : String , _ message : String ,_ actionButtonTitle : String) -> ())?
    
    var webManager : WebManager!
    
    private enum ValidationResults {
        case valid
        case textfieldsEmpty
        case passwordDoesntMatch
        case invalidEmail
    }
    
    var userName: Variable<String>
    var email: Variable<String>
    var password: Variable<String>
    var condfirmPassword: Variable<String>
    var occupation: Variable<String>
    
    var signupButtonTap : PublishSubject<Void>
    var backButtonTap : PublishSubject<Void>
    
    var showLoader : Variable<Bool>
    var dismissViewController: PublishSubject<Void>
    var showAlert: Variable<(AlertsData)>
    
    var disposeBag = DisposeBag()
    
    init(webManager : WebManager) {
        
        self.webManager = webManager

        userName = Variable<String>("")
        email = Variable<String>("")
        password = Variable<String>("")
        condfirmPassword = Variable<String>("")
        occupation = Variable<String>("")
        
        signupButtonTap = PublishSubject<Void>()
        backButtonTap = PublishSubject<Void>()
        
        showLoader = Variable<Bool>(false)
        dismissViewController = PublishSubject<Void>()
      
        let alertData = AlertsData(title: "", message: "", buttonText: nil , type : AlertType.alert)
        showAlert = Variable<AlertsData>(alertData)
        
        setupObservable()

    }
    
    
    func setupObservable(){
        self.signupButtonTap
            .subscribe{  _ in
                let signupRequestCredentials = SignupRequestCredetials(name: self.userName.value, email: self.email.value, password: self.password.value, occupation: self.occupation.value, confirmPassword: self.condfirmPassword.value)
                
                self.didTapOnSignup(with: signupRequestCredentials)
            }
            .disposed(by: disposeBag)
        
        self.backButtonTap
            .subscribe{ _ in
                self.didTapOnBackButton()
        }
            .disposed(by: disposeBag)
    }
  
    func didTapOnBackButton(){
        dismissViewController.onNext(())
    }
    
    func didTapOnSignup(with signupRequestCredentials : SignupRequestCredetials ) {
        
        handleSignupRequest(with: signupRequestCredentials)
        
    }
    
    private func handleSignupRequest(with signupRequestCredentials : SignupRequestCredetials){
        
        let validationResult = validateRequest(of: signupRequestCredentials)
        
        (validationResult == .valid) ? signup(with: signupRequestCredentials) : showAlert(of: validationResult)
    }
    
    
    
    private func validateRequest(of signupRequestCredentials : SignupRequestCredetials)->ValidationResults{
        
        var resultType : ValidationResults!
        
        let textFieldsData = [signupRequestCredentials.email , signupRequestCredentials.name , signupRequestCredentials.password , signupRequestCredentials.occupation]
        
        if(Utils.isTextFieldEmpty(textArray: textFieldsData)){
            resultType = ValidationResults.textfieldsEmpty
            
        }else if(!Utils.isValidEmail(testStr: signupRequestCredentials.email)){
            resultType = ValidationResults.invalidEmail
            
        }else if(signupRequestCredentials.password != signupRequestCredentials.confirmPassword){
            resultType = ValidationResults.passwordDoesntMatch
            
        }else {
            resultType = ValidationResults.valid
            
        }
        
        return resultType
    }
    
    
    
    private func signup(with signupRequestCredentials : SignupRequestCredetials ){
        self.showLoader.value = true
       
        let userData = SignupDTO(name: signupRequestCredentials.name, email: signupRequestCredentials.email, password: signupRequestCredentials.password, occupation: signupRequestCredentials.occupation)
        
        webManager.signup(userData: userData, completion: {   (response) in
            self.showLoader.value = false
            self.showPermissionAlert(for: response.responseCode)
        })
    }
    
    private func showPermissionAlert(for responseCode : Int){
        var data : AlertsData!
       
        data =  (responseCode == 0) ? AlertsData(title: "Signup Failed", message: "Please try again later", buttonText: "OK", type: .permissionAlert) :  AlertsData(title: "Signup Successfull", message: "Please login now to post updates", buttonText: "OK", type: .permissionAlert)
       
        self.showAlert.value = data
    }
  
    private func showAlert(of type : ValidationResults){
        let alertType : AlertType =  .alert
        switch type {
            
        case .invalidEmail:
            let alertData = AlertsData(title: "Invalid Email", message: "Please enter a valid email.", buttonText: nil , type : alertType)
            showAlert.value = alertData
            
        case .passwordDoesntMatch:
            let alertData = AlertsData(title: "Password do not match", message: "Please enter your password again.", buttonText: nil , type : alertType)
            showAlert.value = alertData
            
        case .textfieldsEmpty:
            let alertData = AlertsData(title: "Empty Textfields", message: "Please fill all the text fields", buttonText: nil , type : alertType)
            showAlert.value = alertData
            
        default:
            print("won't reach here")
            
        }
    }
    
    
}
