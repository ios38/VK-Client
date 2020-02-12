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
        let itemsJSONs = json["response"]["items"].arrayValue
        let items = itemsJSONs.map {RealmGroup(from: $0)}
        items.forEach { $0.my = 1 }
        return items
    }

    func parsingFriends(_ data: Data) throws -> [RealmUser] {
        let json = try JSON(data: data)
        let friendsJSONs = json["response"]["items"].arrayValue
        let friends = friendsJSONs.map {RealmUser(from: $0)}
        friends.forEach { $0.my = 1 }
        return friends
    }

    func parsingRealmPhotos(_ data: Data) throws -> [RealmPhoto] {
        let json = try JSON(data: data)
        let photosJSONs = json["response"]["items"].arrayValue
        let photos = photosJSONs.map {RealmPhoto(from: $0)}
        return photos
    }
    
    func parsingPhotos(_ data: Data) throws -> [Photo] {
        let json = try JSON(data: data)
        let photosJSONs = json["response"]["items"].arrayValue
        let photos = photosJSONs.map {Photo(from: $0)}
        return photos
    }

    func parsingAlbums(_ data: Data) throws -> [RealmAlbums] {
        let json = try JSON(data: data)
        let photosJSONs = json["response"]["items"].arrayValue
        let photos = photosJSONs.map {RealmAlbums(from: $0)}
        return photos
    }
    
    func parsingNews(_ data: Data) throws -> [RealmNews] {
        let json = try JSON(data: data)
        let newsJSONs = json["response"]["items"].arrayValue
        let news = newsJSONs.map {RealmNews(from: $0)}
        return news
    }

    func parsingProfiles(_ data: Data) throws -> [RealmUser] {
        let json = try JSON(data: data)
        let itemsJSONs = json["response"]["profiles"].arrayValue
        let items = itemsJSONs.map {RealmUser(from: $0)}
        return items
    }

    func parsingNewsGroups(_ data: Data) throws -> [RealmGroup] {
        let json = try JSON(data: data)
        let itemsJSONs = json["response"]["groups"].arrayValue
        let items = itemsJSONs.map {RealmGroup(from: $0)}
        return items
    }
    
    func parsingNextFrom(_ data: Data) throws -> String {
        let json = try JSON(data: data)
        let items = json["response"]["next_from"].stringValue
        return items
    }

}
