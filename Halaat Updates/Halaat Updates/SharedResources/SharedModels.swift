//
//  SharedModels.swift
//  Halaat Updates
//
//  Created by inVenD on 23/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserModel : Mappable{
    
    enum UserModelKeys  : String{
        case id = "id"
        case name = "name"
        case email = "email"
        case password = "password"
        case occupation = "occupation"
        case updates = "updates"
    }
    
    var id : Int?
    var name : String?
    var email : String?
    var password : String?
    var occupation : String?
    var updates : [Update]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map[UserModelKeys.id.rawValue]
        name <- map[UserModelKeys.name.rawValue]
        email <- map[UserModelKeys.email.rawValue]
        password <- map[UserModelKeys.password.rawValue]
        occupation <- map[UserModelKeys.occupation.rawValue]
        updates <- map[UserModelKeys.updates.rawValue]
    }
}

struct Update : Mappable {
   
    enum UpdateKeys  : String{
        case id = "id"
        case user_id = "user_id"
        case title = "title"
        case description = "description"
        case image = "image"
        case date = "date"
    }
    
    var id : Int?
    var user_id : Int?
    var title : String?
    var description : String?
    var image : String?
    var date : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map[UpdateKeys.id.rawValue]
        user_id <- map[UpdateKeys.user_id.rawValue]
        title <- map[UpdateKeys.title.rawValue]
        description <- map[UpdateKeys.description.rawValue]
        image <- map[UpdateKeys.image.rawValue]
        date <- map[UpdateKeys.date.rawValue]
    }
}
