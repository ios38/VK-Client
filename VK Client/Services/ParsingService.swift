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

    func parsingFriends(_ data: Data) throws -> [RealmUser] {
        let json = try JSON(data: data)
        let friendsJSONs = json["response"]["items"].arrayValue
        let friends = friendsJSONs.map {RealmUser(from: $0)}
        return friends
    }

    func parsingPhotos(_ data: Data) throws -> [RealmPhoto] {
        let json = try JSON(data: data)
        let photosJSONs = json["response"]["items"].arrayValue
        let photos = photosJSONs.map {RealmPhoto(from: $0)}
        return photos
    }

}
