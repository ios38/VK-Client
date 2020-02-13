//
//  Photo.swift
//  VK Client
//
//  Created by Maksim Romanov on 29.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Photo {
    var image: String
    var aspectRatio: Float

    init(from json: JSON) {
        //self.id = json["id"].intValue
        //self.ownerId = json["owner_id"].intValue
        //self.albumId = json["album_id"].intValue
        self.image = json["sizes"][json["sizes"].count - 1]["url"].stringValue
        //self.isLiked = json["likes"]["user_likes"].intValue
        //self.likeCount = json["likes"]["count"].intValue
        
        let width = json["sizes"][json["sizes"].count - 1]["width"].intValue
        let height = json["sizes"][json["sizes"].count - 1]["height"].intValue
        //self.type = width > height ? "landscape" : "portrait"
        self.aspectRatio = width != 0 ? Float(height)/Float(width) : Float(0)
    }
}

class RealmPhoto: Object {
    @objc dynamic var id = -1
    @objc dynamic var ownerId = -1
    @objc dynamic var albumId = ""
    @objc dynamic var image = ""
    @objc dynamic var type = ""
    @objc dynamic var aspectRatio: Float = 0
    @objc dynamic var isLiked = 0
    @objc dynamic var likeCount = 0
    
    let friends = LinkingObjects(fromType: RealmUser.self, property: "photos")

    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.albumId = json["album_id"].stringValue
        self.image = json["sizes"][json["sizes"].count - 1]["url"].stringValue
        self.isLiked = json["likes"]["user_likes"].intValue
        self.likeCount = json["likes"]["count"].intValue
        
        let width = json["sizes"][json["sizes"].count - 1]["width"].intValue
        let height = json["sizes"][json["sizes"].count - 1]["height"].intValue
        self.type = width > height ? "landscape" : "portrait"
        self.aspectRatio = width != 0 ? Float(height)/Float(width) : Float(0)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

/*
 {
     "response": {
         "count": 1,
         "items": [
             {
                 "id": 456239022,
                 "album_id": -6,
                 "owner_id": 66389471,
                 "sizes": [
                     {
                         "type": "m",
                         "url": "https://sun9-64.userapi.com/c837422/v837422471/27f86/0IxbaSXiiy8.jpg",
                         "width": 130,
                         "height": 87
                     },
                     {
                         "type": "o",
                         "url": "https://sun9-10.userapi.com/c837422/v837422471/27f8a/-HquQ_2pgsg.jpg",
                         "width": 130,
                         "height": 87
                     },
                     {
                         "type": "p",
                         "url": "https://sun9-19.userapi.com/c837422/v837422471/27f8b/vSh5siA1i4s.jpg",
                         "width": 200,
                         "height": 133
                     },
                     {
                         "type": "q",
                         "url": "https://sun9-22.userapi.com/c837422/v837422471/27f8c/9JGvkZIsKQk.jpg",
                         "width": 320,
                         "height": 213
                     },
                     {
                         "type": "r",
                         "url": "https://sun9-39.userapi.com/c837422/v837422471/27f8d/8Kero0lljSo.jpg",
                         "width": 510,
                         "height": 340
                     },
                     {
                         "type": "s",
                         "url": "https://sun9-43.userapi.com/c837422/v837422471/27f85/4tcHDbTx45E.jpg",
                         "width": 75,
                         "height": 50
                     },
                     {
                         "type": "x",
                         "url": "https://sun9-55.userapi.com/c837422/v837422471/27f87/53h_FOd5sH4.jpg",
                         "width": 604,
                         "height": 403
                     },
                     {
                         "type": "y",
                         "url": "https://sun9-30.userapi.com/c837422/v837422471/27f88/Z6GVN7LANY0.jpg",
                         "width": 807,
                         "height": 538
                     },
                     {
                         "type": "z",
                         "url": "https://sun9-71.userapi.com/c837422/v837422471/27f89/f3qNFrrAmLI.jpg",
                         "width": 960,
                         "height": 640
                     }
                 ],
                 "text": "",
                 "date": 1486993249,
                 "post_id": 3,
                 "likes": {
                     "user_likes": 0,
                     "count": 4
                 },
                 "reposts": {
                     "count": 0
                 }
             }
         ]
     }
 }
 */
