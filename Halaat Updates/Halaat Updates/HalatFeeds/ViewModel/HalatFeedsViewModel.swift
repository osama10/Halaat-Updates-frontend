//
//  HalatFeedsViewModel.swift
//  Halaat Updates
//
//  Created by inVenD on 26/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import ObjectMapper

protocol HalatFeedsViewModel {
  
    var user : UserModel? {get}
    var feeds : [Update]?{get}
    
    var refreshHalaatWall : (()->())?{get set}
    var showAlert : ((_ title : String , _ message : String )->())?{get set}
    var success : (()->())?{get set}
    var showLoader : (()->())?{get set}
    var hideLoader : (()->())?{get set}
    
    func numberOfRows()->Int
    func heightForRow()->Double
    func getAllFeeds()
    func getHalatFeedsCellViewModel(of index : Int)->HalatFeedsCellViewModel
}

class HalatFeedsViewModelImp : HalatFeedsViewModel {
    enum HeightOfRow : Double{
        case heightOfRow = 300.0
    }
    
    var user: UserModel?
    var feeds: [Update]?
    var webManager : WebManager?
    
    var refreshHalaatWall: (() -> ())?
    var showAlert : ((_ title : String , _ message : String )->())?
    var success : (()->())?
    var showLoader : (()->())?
    var hideLoader : (()->())?
    
    init(user : UserModel , webManager : WebManager) {
        self.user = user
        self.webManager = webManager
    }
    
    func numberOfRows() -> Int {
        guard let feeds = self.feeds else {return 0}
        return feeds.count
    }
    
    func heightForRow() -> Double {
        return HeightOfRow.heightOfRow.rawValue
    }
    
    func getAllFeeds() {
        
        webManager?.getAllFeeds(completion: { [weak self](response) in
            guard let this = self else{return}
            this.hideLoader?()
            
            if(response.responseCode == 0){
                this.showAlert?("No Feeds fetched" , response.response["response"] as? String ?? "There is something wrong. Please try later.")
            }else{
                let responseBody = (response.response["response"] as! [String : AnyObject])["responseBody"] as! [String : AnyObject]
                let feedsDict = responseBody["Data"] as! [[String  : AnyObject]]
                let feedsArray = Mapper<Update>().mapArray(JSONArray: feedsDict)
                if(feedsArray.count <= 0) {
                    this.showAlert?("No Feeds fetched" , "There is no updates yet ")
                    return
                }
                this.feeds = feedsArray
                this.refreshHalaatWall?()
            }
        })
    }
    
    func getHalatFeedsCellViewModel(of index: Int) -> HalatFeedsCellViewModel {
        return HalatFeedsCellViewModelImp(feed: feeds![index])
    }
}
