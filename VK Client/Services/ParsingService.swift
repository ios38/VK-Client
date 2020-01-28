//
//  ParsingService.swift
//  VK Client
//
//  Created by Maksim Romanov on 24.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParsingService {
    
    func parsingGroups(_ data: Data) throws -> [RealmGroup] {
        let json = try JSON(data: data)
        let groupsJSONs = json["response"]["items"].arrayValue
        let groups = groupsJSONs.map {RealmGroup(from: $0)}
        return groups
    }

}
