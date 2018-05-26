//
//  HalatFeedsCellViewModel.swift
//  Halaat Updates
//
//  Created by inVenD on 27/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation

protocol HalatFeedsCellViewModel {

    var feed : Update?{get set}
    
    var setData : ((_ feed : Update)->())?{get set}
    var setUI : (()->())?{get set}
    var setDefaultImage : ((_ defaulImagetUrl : String)->())?{get set}
    var setImageFromUrl : ((_ imageUrl : URL)->())?{get set}
    
    func viewModelDidBinUI()
    func setImage(accordingTo imageUrl : String)
}

struct HalatFeedsCellViewModelImp : HalatFeedsCellViewModel {
    var feed: Update?
    
    var setData: ((Update) -> ())?
    var setUI: (() -> ())?
    var setDefaultImage: ((String) -> ())?
    var setImageFromUrl: ((URL) -> ())?
    
    init(feed : Update) {
        self.feed = feed
    }
    
    func viewModelDidBinUI() {
        setUI?()
        setData?(self.feed!)
    }
    
    func setImage(accordingTo imageUrl: String) {
        (imageUrl == "none") ? setDefaultImage?(imageUrl) : setImageFromUrl?(URL(string: imageUrl)!)
    }
}
