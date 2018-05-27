//
//  HalatFeedsCellViewModel.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 27/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation

protocol HalatFeedsCellViewModel {

    var feed : Update?{get set}
    
    var setData : (()->())?{get set}
    var setUI : (()->())?{get set}
    var setDefaultImage : ((_ defaulImagetUrl : String)->())?{get set}
    var setImageFromUrl : ((_ imageUrl : URL)->())?{get set}
    
    func viewModelDidBinUI()
    func setImage()
    func setTitleOfFeed()->String
    func setAuthorOfFeed()->String
    func setDateOnWhichFeedPosted()->String
}

struct HalatFeedsCellViewModelImp : HalatFeedsCellViewModel {
   
    
   
    var feed: Update?
    
    var setData: (() -> ())?
    var setUI: (() -> ())?
    var setDefaultImage: ((String) -> ())?
    var setImageFromUrl: ((URL) -> ())?
    
    init(feed : Update) {
        self.feed = feed
    }
    
    func viewModelDidBinUI() {
        setUI?()
        setData?()
    }
    
    func setImage() {
        let imageUrl = feed?.image ?? "none"
        (feed?.image == "none") ? setDefaultImage?(imageUrl) : setImageFromUrl?(URL(string: imageUrl)!)
    }
    func setTitleOfFeed() -> String {
        guard let title = feed?.title else {return ""}
        return title
    }
    func setAuthorOfFeed() -> String {
        guard let authorName = feed?.user?.name else { return "" }
        return "Posted By : \(authorName)"
    }
    func setDateOnWhichFeedPosted() -> String {
        guard let date = feed?.date else { return "" }
        return "Date : \(date)"
    }
}
