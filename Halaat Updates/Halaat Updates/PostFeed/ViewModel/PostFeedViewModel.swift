//
//  PostFeedViewModel.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 27/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation

protocol PostFeedViewModel{
    
    var user : UserModel{get}
    var webManager : WebManager{get}
    
    var makeTitleEditable : (()->())?{get set}
    var makeDescriptionEditable : (()->())?{get set}
    var openImagePickerController : (()->())?{get set}
    var showAlert : ((_ title : String , _ message : String)->())?{get set}
    var showPermissionAlert : ((_ title : String , _ message : String , _ actionButtonTitle : String )->())?{get set}
    var dismissViewController : (() -> ())?{get set}
    var showLoader :(()->())?{get set}
    var hideLoader :(()->())?{get set}
    
    func didTapOnPostButton(feed :PostModel)
    func didTapOnEditTitleButton()
    func didTapOnEditDescriptionButton()
    func didTapOnPicture()
    func cameraNotAvailable()
    func didTapOnCancel()
    func didTapOnSelectPicture()
}

struct PostFeedViewModelImp : PostFeedViewModel {
    
    var user: UserModel
    var webManager: WebManager
    
    var makeTitleEditable: (() -> ())?
    var makeDescriptionEditable: (() -> ())?
    var openImagePickerController: (() -> ())?
    var showAlert: ((String, String) -> ())?
    var dismissViewController : (() -> ())?
    var showLoader: (() -> ())?
    var showPermissionAlert: ((String, String, String) -> ())?
    var hideLoader: (() -> ())?
    
    init(user : UserModel , webManager : WebManager) {
        self.webManager = webManager
        self.user = user
    }
    
    func didTapOnPostButton(feed :PostModel) {
        self.showLoader?()
        postFeed(with: feed)
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
    
    private func postFeed(with feed : PostModel){
        webManager.postFeed(postData: feed) { (response) in
            self.hideLoader?()
            self.handlePostFeedResponse(response: response)
        }
    }
    
    private func handlePostFeedResponse(response : Response){
        
        (response.responseCode == 0) ? self.showPermissionAlert?("" , "Something unexpected occur , please try alter" , "OK") : self.showPermissionAlert?("Feed Posted" , "Your feed posted successfully" , "OK")
    }
}
