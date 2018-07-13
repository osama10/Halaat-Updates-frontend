//
//  LoginViewController.swift
//  Friend Finder
//
//  Created by Osama Bin Bashir on 20/03/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController , SegueHandlerType , AlertsPresentable  {
    
    enum SegueIdentifier  : String {
        case mainview
        case signupview
    }
    
    @IBOutlet fileprivate weak var tfEmail : UITextField!
    @IBOutlet fileprivate weak var tfPassword : UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    var disposeBag = DisposeBag()
    
    var viewModel : SignInViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignInViewModelImp(webManager: WebManagerImp())
        bindUI()
    }
    
    private func bindUI(){
        textFieldBindings()
        buttonBindings()
        actionsBindings()
    }
    
    private func textFieldBindings(){
       
        tfEmail.rx.text
            .map{$0 ?? ""}
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        tfPassword.rx.text
            .map{$0 ?? ""}
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        let emailDidEndObservable = tfEmail.rx.controlEvent(.editingDidEnd).asObservable()
        let passwordDidEndObservable = tfPassword.rx.controlEvent(.editingDidEnd).asObservable()
        
        Observable.combineLatest(emailDidEndObservable, passwordDidEndObservable)
            .subscribe({ [weak self] _ in
                guard let `self` =  self else { return }
                self.viewModel.didReturnPressed()
            })
            .disposed(by: disposeBag)
    
    }
    
    private func buttonBindings(){
        
        btnSignIn.rx.tap
            .bind(to : viewModel.signinButtonTap)
            .disposed(by: disposeBag)
    }
    
    private func actionsBindings(){
        viewModel.showLoader.asObservable()
            .subscribe(onNext :{  [weak self] bool in
                guard let `self` =  self else { return }
                (bool) ? self.view.makeToastActivity(.center) : self.view.hideToastActivity()
            })
            .disposed(by: disposeBag)
        
        viewModel.closeKeyboard.asObservable()
            .subscribe(onNext :{  [weak self] bool in
                guard let `self` =  self else { return }
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.showAlert.asObservable()
            .subscribe(onNext: { [weak self] (title , message) in
                guard let `self` =  self else { return }
                self.showAlert(with: title, and: message)
            })
            .disposed(by: disposeBag)
     
        viewModel.loginToMainView.asObservable()
            .subscribe(onNext: { [weak self](doLogin) in
                guard let `self` =  self else { return }
                if(doLogin){
                    self.performSegueWithIdentifier(segueIdentifier: .mainview, sender: self)
                }
            })
            .disposed(by: disposeBag)
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
