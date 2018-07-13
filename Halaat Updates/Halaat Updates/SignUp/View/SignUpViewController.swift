//
//  SignUpViewController.swift
//  Halaat Updates
//
//  Created by inVenD on 28/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import UIKit
import RxSwift

class SignUpViewController: UIViewController , Injectable , AlertsPresentable {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var btnSignup : UIButton!
    @IBOutlet weak var btnBack : UIButton!
    
    var viewModel : SignupViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        bindUI()
    }
    
    func inject(_ viewModel : SignupViewModel) {
        self.viewModel = viewModel
    }
    
    func assertDependencies() {
        assert(viewModel != nil)
    }
    
    private func bindUI(){
        textFieldBindings()
        buttonsEventsbindings()
        actionsBindings()
    }
    
    private func textFieldBindings(){
        nameTextField.rx.text
            .map{ $0 ?? ""}
            .bind(to: viewModel.userName)
            .disposed(by: disposeBag)
        emailTextField.rx.text
            .map{ $0 ?? ""}
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        passwordTextField.rx.text
            .map{ $0 ?? ""}
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        confrimPasswordTextField.rx.text
            .map{ $0 ?? ""}
            .bind(to: viewModel.condfirmPassword)
            .disposed(by: disposeBag)
        occupationTextField.rx.text
            .map{ $0 ?? ""}
            .bind(to: viewModel.occupation)
            .disposed(by: disposeBag)
    }
    
    private func buttonsEventsbindings(){
        btnSignup.rx.tap
            .bind(to : viewModel.signupButtonTap)
            .disposed(by: disposeBag)
        
        btnBack.rx.tap
            .bind(to: viewModel.backButtonTap )
            .disposed(by : disposeBag)
    }
    
    private func actionsBindings(){
        viewModel.showLoader.asObservable()
            .subscribe( onNext : { [weak self] (showLoader) in
                guard let `self` = self else { return }
                (showLoader) ? self.view.makeToastActivity(.center) : self.view.hideToastActivity()
            })
            .disposed(by: disposeBag)
        
        viewModel.dismissViewController.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.showAlert.asObservable()
            .subscribe(onNext: { [weak self] alertData in
                guard let `self` = self else { return }
                (alertData.type == .alert) ? self.showAlert(with: alertData) : self.showPermissionAlert(with: alertData)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func  showAlert(with alertData : AlertsData){
        self.showAlert(with: alertData.title, and: alertData.message)
    }
    
    private func showPermissionAlert(with alertData : AlertsData){
        
        self.showPermissionAlert(title: alertData.title, message: alertData.message, actionButtonTitle: alertData.buttonText ?? "OK") { [weak self] in 
            guard let `self` = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
