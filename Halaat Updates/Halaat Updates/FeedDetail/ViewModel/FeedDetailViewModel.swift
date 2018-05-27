//
//  FeedDetailViewModel.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 27/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import Foundation

protocol FeedDetailViewModel {
    var feed : Update{get}
    
    func setTitle()->String
    func setAuthor()->String
    func setDatePosted()->String
    func setDetails()->String
}


class FeedDetailViewModelImp: FeedDetailViewModel {
    
    var feed: Update
    
    init(feed : Update) {
        self.feed = feed
    }
    
    func setTitle() -> String {
        return feed.title ?? ""
    }
    
    func setAuthor() -> String {
        guard let author = feed.user?.name else {return ""}
        return "Posted By : \(author)"
    }
    
    func setDatePosted() -> String {
        guard let date = feed.date else {return ""}
        return "Date : \(date)"
    }
    
    func setDetails() -> String {
        guard let details = feed.description else {return ""}
        return "\(details)"
    }
    
}
