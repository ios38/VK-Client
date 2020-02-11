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

    static func loadAlbums(owner: Int) -> Promise<Data> {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAlbums"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            "owner_id": owner,
            "count": 5,
            "extended": 1,
            "v": "5.92"
        ]

        return NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseData().map { $0.data }
    }
    /*
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
                let newsJSONs = json["response"]["items"].arrayValue
                let news = newsJSONs.map {RealmNews(from: $0)}
                completion?(.success(news))
            case let .failure(error):
                completion?(.failure (error))
            }
        }
    }*/
    
    static func loadNews() -> Promise<Data> {
        let baseUrl = "https://api.vk.com"
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": Session.shared.accessToken,
            //"source_ids": 13807983,
            "filters": "post",
            "count": 10,
            "extended": 1,
            "v": "5.92"
        ]
        
        return NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseData().map { $0.data }
    }
    
    static func loadNewsWithStart(startTime: Double? = nil, startFrom: String? = nil, completion: @escaping ([RealmNews], Data, String) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: Session.shared.accessToken),
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        if let startTime = startTime {
            components.queryItems?.append(URLQueryItem(name: "start_time", value: String(startTime)))
        }
        if let startFrom = startFrom {
            components.queryItems?.append(URLQueryItem(name: "start_from", value: startFrom))
        }
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data,
                let json = try? JSON(data: data) else { return }
            //print ("NetworkService: loadNewsWithStart: \(json)")
            let newsJSON = json["response"]["items"].arrayValue
            let news = newsJSON.map { RealmNews(from: $0) }
            let nextFrom = json["response"]["next_from"].stringValue
            
            DispatchQueue.main.async {
                completion(news, data, nextFrom)
            }
            
        }
        task.resume()
    }

}
