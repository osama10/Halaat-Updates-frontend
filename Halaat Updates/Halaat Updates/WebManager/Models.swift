//
//  Models.swift
//  Halaat Updates
//
//  Created by inVenD on 28/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import Alamofire

struct Request {
    var url = String()
    var httpMethod : HTTPMethod = .get
    var params : [String : AnyObject]?
    var headers : [String : String]?
}

struct Response {
    var responseCode = -1
    var response = [String : AnyObject]()
}


