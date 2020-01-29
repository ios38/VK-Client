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
import PromiseKit

class NetworkService {
    static let session: Alamofire.SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session = Alamofire.SessionManager(configuration: config)
        return session
    }()
    /*
    static func loadGroups(completion: ((Swift.Result<[RealmGroup], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
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
    }*/
    
    static func loadGroups() -> Promise<Data> {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            //"count": 5,
            "extended": 1,
            "v": "5.92"
        ]
        
        return NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseData().map { $0.data }
    }

    static func searchGroups(token: String, searchText: String, completion: ((Swift.Result<[RealmGroup], Error>) -> Void)? = nil) {
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
    /*
    static func loadFriends(token: String, completion: ((Swift.Result<[RealmUser], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "fields": "photo_100",
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
    }*/

    static func loadFriends() -> Promise<Data> {
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            "fields": "photo_100",
            "extended": 1,
            "v": "5.92"
        ]
        
        return NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseData().map { $0.data }
    }
    /*
    static func loadPhotos(owner: Int, album: Int?, completion: ((Swift.Result<[RealmPhoto], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
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
    }*/
    
    static func loadPhotos(owner: Int, album: Int?, completion: ((Swift.Result<Data, Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            "owner_id": owner,
            "album_id": album as Any,
            "count": 15,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseData { response in
            switch response.result {
            case let .success(data):
                completion?(.success(data))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }
    /*
    static func loadAlbum(token: String, owner: Int, album: Int, completion: ((Swift.Result<[RealmPhoto], Error>) -> Void)? = nil) {
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
    }*/
    
    static func loadAlbum(owner: Int, album: Int) -> Promise<Data> {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.get"

        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            "owner_id": owner,
            "album_id": album,
            "count": 10,
            "extended": 1,
            "v": "5.92"
        ]
        
        return NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseData().map { $0.data }
    }

    /*
    static func loadAlbums(token: String, owner: Int, completion: ((Swift.Result<[RealmAlbums], Error>) -> Void)? = nil) {
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
    }*/

    static func loadAlbums(owner: Int) -> Promise<Data> {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAlbums"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            "owner_id": owner,
            "count": 3,
            "extended": 1,
            "v": "5.92"
        ]

        return NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseData().map { $0.data }
    }

    static func loadNews(token: String, completion: ((Swift.Result<[RealmNews], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "source_ids": 13807983,
            "filters": "post",
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
                //print(newsJSONs)
                let news = newsJSONs.map {RealmNews(from: $0)}
                //print("NetworkService: loadNews: \(news)")
                completion?(.success(news))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }
    
}
