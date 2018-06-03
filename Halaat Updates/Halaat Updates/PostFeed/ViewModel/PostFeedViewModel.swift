//
//  PostFeedViewModel.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 27/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation

protocol PostFeedViewModel{
    
    var user : UserModel{get set}
    
    var makeTitleEditable : (()->())?{get set}
    var makeDescriptionEditable : (()->())?{get set}
    var openImagePickerController : (()->())?{get set}
    var showAlert : ((_ title : String , _ message : String)->())?{get set}
    var dismissViewController : (() -> ())?{get set}
    
    func didTapOnPostButton()
    func didTapOnEditTitleButton()
    func didTapOnEditDescriptionButton()
    func didTapOnPicture()
    func cameraNotAvailable()
    func didTapOnCancel()
    func didTapOnSelectPicture()
}

class PostFeedViewModelImp : PostFeedViewModel {
    
    var user: UserModel
    
    var makeTitleEditable: (() -> ())?
    var makeDescriptionEditable: (() -> ())?
    var openImagePickerController: (() -> ())?
    var showAlert: ((String, String) -> ())?
    var dismissViewController : (() -> ())?
    
    init(user : UserModel) {
        self.user = user
    }
    
    func didTapOnPostButton() {
        
    }
    
    func didTapOnEditTitleButton() {
        makeTitleEditable?()
    }
    
    func didTapOnEditDescriptionButton() {
        makeDescriptionEditable?()
    }
    
    func didTapOnPicture() {
        openImagePickerController?()
    }
    
    func cameraNotAvailable() {
        showAlert?("Camera not supported" , "Your device has no support for camera")
    }
    
    func didTapOnCancel(){
        dismissViewController?()
    }
    
    func didTapOnSelectPicture(){
        openImagePickerController?()
    }
}
