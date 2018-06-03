//
//  LoginViewController.swift
//  Friend Finder
//
//  Created by Osama Bin Bashir on 20/03/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController , SegueHandlerType , AlertsPresentable  {
    enum SegueIdentifier  : String {
        case mainview
        case signupview
    }
    
    @IBOutlet fileprivate weak var tfEmail : UITextField!
    @IBOutlet fileprivate weak var tfPassword : UITextField!
    
    var viewModel : SignInViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignInViewModelImp(webManager: WebManagerImp())
        bindUI()
    }
    
    private func bindUI(){
        viewModel.showAlert = {[weak self] (title , message) in
            guard let this = self else {return}
            this.showAlert(with: title, and: message)
        }
        viewModel.showLoader = { [weak self] in
            guard let this = self else {return}
            this.view.makeToastActivity(.center)
        }
        viewModel.hideLoader = { [weak self] in
            guard let this = self else {return}
            this.view.hideToastActivity()
        }
        viewModel.success = { [weak self]  in
            guard let this = self else {return}
            this.performSegueWithIdentifier(segueIdentifier: .mainview, sender: self)
        }
        viewModel.returnPressed = { [weak self] in
            guard let this = self else {return}
            this.view.endEditing(true)
        }
    }
    
    @IBAction func didTapOnLogin(sender : UIButton){
        viewModel.didTapOnLogin(email: tfEmail.text!, password: tfPassword.text!)
    }
    
    
    
    @IBAction func returnPressed(sender: UITextField) {
        viewModel.didReturnPressed()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue){
       
        case .mainview :
            let destVC = (segue.destination as! UINavigationController).viewControllers.first as! HalatFeedsViewController
            destVC.inject(viewModel.getHalatFeedsViewModel(user: viewModel.user!))
        case .signupview:
            let destVc = segue.destination as! SignUpViewController
            destVc.inject(viewModel.getSignupViewModel())
        
        }
    }
}
