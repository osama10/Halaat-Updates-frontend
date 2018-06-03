//
//  SignUpViewController.swift
//  Halaat Updates
//
//  Created by inVenD on 28/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController , Injectable , AlertsPresentable {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
 
    var viewModel : SignupViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        bindUI()
    }

    private func bindUI(){
        viewModel.dismissViewController = { [weak self] in
            guard let this = self else{return}
            this.dismiss(animated: true, completion: nil)
        }
        viewModel.showAlert = {[weak self] (title , message) in
            guard let this = self else {return}
            this.showAlert(with: title, and: message)
        }
        viewModel.showPermissionAlert = {[weak self] (title , message , actionButtonTitle) in
            guard let this = self else {return}
            this.showPermissionAlert(title: title, message: message, actionButtonTitle: actionButtonTitle, completion: { [weak self] in
                guard let this = self else {return}
                this.dismiss(animated: true, completion: nil)
            })
        }
        viewModel.hideLoader = {[weak self]  in
            guard let this = self else {return}
            this.view.hideAllToasts()
        }
        
        viewModel.showLoader = { [weak self] in
            guard let this = self else {return}
            this.view.makeToastActivity(.center)
        }
    }
   
    func inject(_ viewModel : SignupViewModel) {
        self.viewModel = viewModel
    }
    
    func assertDependencies() {
        assert(viewModel != nil)
    }
  
    @IBAction func didTapOnSignupButton(_ sender: UIButton) {
     
        let signupRequestCredentials = SignupRequestCredetials(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, occupation: occupationTextField.text!, confirmPassword: confrimPasswordTextField.text!)
        
        viewModel.didTapOnSignup(with: signupRequestCredentials)
    }
    
    @IBAction func didTapOnBackButton(sender : UIButton){
        viewModel.didTapOnBackButton()
    }
}
