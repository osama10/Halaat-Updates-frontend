//
//  SignupViewModel.swift
//  Halaat Updates
//
//  Created by inVenD on 28/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation

protocol SignupViewModel {
  
    var showLoader : (()->())?{get set}
    var hideLoader : (()->())?{get set}
    var showAlert : ((_ title : String , _ message : String)->())?{get set}
    var showPermissionAlert : ((_ title : String , _ message : String , _ actionButtonTitle : String )->())?{get set}
    var dismissViewController : (()->())?{get set}

    func didTapOnBackButton()
    func didTapOnSignup(with signupRequestCredentials : SignupRequestCredetials )
}

struct SignupViewModelImp : SignupViewModel {
  
    var showLoader : (()->())?
    var hideLoader : (()->())?
    var showAlert: ((_ title : String , _ message : String) -> ())?
    var showPermissionAlert: ((_ title : String , _ message : String ,_ actionButtonTitle : String) -> ())?
    var dismissViewController : (()->())?
    
    var webManager : WebManager!
    
    private enum ValidationResults {
        case valid
        case textfieldsEmpty
        case passwordDoesntMatch
        case invalidEmail
    }
    
    init(webManager : WebManager) {
        self.webManager = webManager
    }
    
    func didTapOnBackButton(){
        dismissViewController?()
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
       
        showLoader?()
        
        let userData = SignupDTO(name: signupRequestCredentials.name, email: signupRequestCredentials.email, password: signupRequestCredentials.password, occupation: signupRequestCredentials.occupation)
        
        webManager.signup(userData: userData, completion: {   (response) in
            self.hideLoader?()
            (response.responseCode == 0) ? self.showPermissionAlert?("Signup Failed" , "Please try again later" , "OK") : self.showPermissionAlert?("Signup Successfull" , "Please login now to post updates" , "OK")
        })
    }
    
    private func showAlert(of type : ValidationResults){
        switch type {
       
        case .invalidEmail:
            showAlert?("Invalid Email" , "Please enter a valid email.")

        case .passwordDoesntMatch:
            showAlert?("Password do not match" , "Please enter your password again.")

        case .textfieldsEmpty:
            showAlert?("Empty Textfields" , "Please fill all the text fields")

        default:
            print("won't reach here")
        }
    }
    
   
}
