//
//  Repository.swift
//  Multi-Thread-Network
//
//  Created by JHH on 31/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation
import ObjectMapper


class Repository:Mappable {
    var identifier : Int!
    var language   : String!
    var url        : String!
    var name       : String!
    
    required init?(map : Map){ }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
