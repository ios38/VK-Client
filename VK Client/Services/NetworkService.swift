//
//  NetworkService.swift
//  VK Client
//
//  Created by Maksim Romanov on 03.12.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    static let session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: config)
        return session
    }()

    static func loadGroups(token: String, completion: ((Result<[RealmGroup], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            //"count": 5,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let groupsJSONs = json["response"]["items"].arrayValue
                let groups = groupsJSONs.map {RealmGroup(from: $0)}
                //print("NetworkService: groups: \(groups)")
                completion?(.success(groups))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }
    
    static func loadFriends(token: String, completion: ((Result<[RealmUser], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "fields": "photo_200",
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let friendsJSONs = json["response"]["items"].arrayValue
                let friends = friendsJSONs.map {RealmUser(from: $0)}
                //print("NetworkService: friends: \(friends)")
                completion?(.success(friends))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }

    static func loadPhotos(token: String, owner: Int, album: Int?, completion: ((Result<[RealmPhoto], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": owner,
            "album_id": album as Any,
            "count": 15,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let photosJSONs = json["response"]["items"].arrayValue
                let photos = photosJSONs.map {RealmPhoto(from: $0)}
                //print("owner_id \(owner) photos: \(photos)")
                completion?(.success(photos))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }
    
    static func loadAlbum(token: String, owner: Int, album: Int, completion: ((Result<[RealmPhoto], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.get"

        let params: Parameters = [
            "access_token": token,
            "owner_id": owner,
            "album_id": album,
            "count": 10,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let photosJSONs = json["response"]["items"].arrayValue
                let photos = photosJSONs.map {RealmPhoto(from: $0)}
                //print("owner_id \(owner) photos: \(photos)")
                completion?(.success(photos))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }

    static func loadAlbums(token: String, owner: Int, completion: ((Result<[RealmAlbums], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAlbums"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": owner,
            "count": 3,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                //print(json)
                let newsJSONs = json["response"]["items"].arrayValue
                let news = newsJSONs.map {RealmAlbums(from: $0)}
                completion?(.success(news))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }

    static func searchGroups(token: String, searchText: String, completion: ((Result<[RealmGroup], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": token,
            "q": searchText,
            "count": 10,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let groupsJSONs = json["response"]["items"].arrayValue
                let groups = groupsJSONs.map {RealmGroup(from: $0)}
                //print("NetworkService: searchGroups: \(groups)")
                completion?(.success(groups))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }

}
