//
//  DateUtils.swift
//  Friend Finder
//
//  Created by inVenD on 21/03/2018.
//  Copyright © 2018 inVenD. All rights reserved.
//

import Foundation

class DateUtils{
    public static func getTimeStamp()->String{
        
        return String(Date().timeIntervalSince1970)
    }
    
    public static func getHours(timeStamp : String)->String{
        
        let lastUpdateTime = Date(timeIntervalSince1970: Double(timeStamp)!)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour, .minute]
        let userLastLocationTimeString = formatter.string(from: lastUpdateTime , to : Date()) ?? ""
        return userLastLocationTimeString
        
    }
}

