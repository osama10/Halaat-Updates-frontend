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
    
    func didTapOnPostButton()
}

class PostFeedViewModelImp : PostFeedViewModel {
    
    var user: UserModel
    
    init(user : UserModel) {
        self.user = user
    }
    
    func didTapOnPostButton() {
        
    }
}
