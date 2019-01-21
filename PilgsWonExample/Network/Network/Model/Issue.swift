//
//  Issue.swift
//  Network
//
//  Created by JHH on 21/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation
import Mapper

struct Issue : Mappable {
    let identifier : Int
    let number     : Int
    let title      : String
    let body       : String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number     = map.from("number")
        try title      = map.from("title")
        try body       = map.from("body")
    }
}
