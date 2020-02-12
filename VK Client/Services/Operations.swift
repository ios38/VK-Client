//
//  Operations.swift
//  Operations
//
//  Created by Maksim Romanov on 24.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class GetData : AsyncOperation {
    private var ownerId: Int
    private var albumId: Int?
    var data: Data?
    
    override func main() {
        
        NetworkService.loadPhotos(owner: ownerId, album: albumId) { [weak self] result in
            guard let self = self else { return }
            guard case let .success(data) = result else { return }
            self.data = data
            //print("1_Operations: GetData: \(String(describing: self.data))")
            self.state = .finished
        }
        /*
        NetworkService.fetchPhotos(owner: ownerId, album: nil) { result in
            switch result {
            case let .success(data):
                self.data = data
                self.state = .finished
                //try? RealmService.save(items: photos)
            case let .failure(error):
                print(error)
            }
        }*/
    }

    init (ownerId: Int, albumId: Int?) {
        self.ownerId = ownerId
        self.albumId = albumId
    }
}

class ParseData: Operation {
    private let parsingService = ParsingService()
    var outputData: [RealmPhoto] = []
    
    override func main() {
        guard let getData = dependencies.first as? GetData, let data = getData.data else { return }
        do {
            outputData = try self.parsingService.parsingRealmPhotos(data)
            /*
            let json = try JSON(data: data)
            let postsJSONs = json["response"]["items"].arrayValue
            let posts = postsJSONs.map {RealmPhoto(from: $0)}
            outputData = posts
            print("3_Operations: ParseData: \(outputData.count)")
             */
        } catch {
            print(error)
        }
    }
}

class SaveData: Operation {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    var posts: [RealmPhoto] = []
    
    override func main() {
        guard let parseData = dependencies.first as? ParseData else { return }
        try? RealmService.save(items: parseData.outputData)
        //print("5_Operations: SaveData: \(parseData.outputData.count) items")
    }
            
}

