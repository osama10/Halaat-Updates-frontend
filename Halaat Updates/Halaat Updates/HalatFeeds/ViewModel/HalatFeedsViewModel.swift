//
//  HalatFeedsViewModel.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 26/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
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
    var performSegueToFeedDetails : (()->())?{get set}
    var performSegueToPostFeedView : (()->())?{get set}
    var performLogout : (()->())?{get set}
    
    func numberOfRows()->Int
    func heightForRow()->Double
    func didSelectRow(at index : Int)
    func getAllFeeds()
    func didTapOnLogoutButton()
    func getHalatFeedsCellViewModel(of index : Int)->HalatFeedsCellViewModel
    func getFeedDetailViewModel()->FeedDetailViewModel
    func getPostFeedViewModel()->PostFeedViewModel
}

class HalatFeedsViewModelImp : HalatFeedsViewModel {
    enum HeightOfRow : Double{
        case heightOfRow = 350.0
    }
    
    var user: UserModel?
    var feeds: [Update]?
    var webManager : WebManager?
    
    var refreshHalaatWall: (() -> ())?
    var showAlert : ((_ title : String , _ message : String )->())?
    var success : (()->())?
    var showLoader : (()->())?
    var hideLoader : (()->())?
    var performSegueToFeedDetails: (() -> ())?
    var performSegueToPostFeedView: (() -> ())?
    var performLogout: (() -> ())?
    
    fileprivate var selectedIndex = -1
    
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
    func didSelectRow(at index: Int) {
        selectedIndex = index
        performSegueToFeedDetails?()
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
    
    func didTapOnLogoutButton() {
        performLogout?()
    }
    func getHalatFeedsCellViewModel(of index: Int) -> HalatFeedsCellViewModel {
        return HalatFeedsCellViewModelImp(feed: feeds![index])
    }
    func getFeedDetailViewModel() -> FeedDetailViewModel {
        return FeedDetailViewModelImp(feed: feeds![selectedIndex])
    }
    
    func getPostFeedViewModel()->PostFeedViewModel{
        return PostFeedViewModelImp(user: user!, webManager: self.webManager!)
    }
}
