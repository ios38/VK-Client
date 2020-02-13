//
//  Albums.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class RealmAlbum: Object {
    @objc dynamic var id = -1
    @objc dynamic var ownerId = -1
    @objc dynamic var date = Date.distantPast
    @objc dynamic var text = ""
    @objc dynamic var size = -1

    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        let dateDouble = json["updated"].doubleValue
        self.date = Date(timeIntervalSince1970: dateDouble)
        self.text = json["title"].stringValue
        self.size = json["size"].intValue

        //self.albumId = json["attachments"][0]["album"]["id"].intValue
        //self.isLiked = json["likes"]["user_likes"].intValue
        //self.likeCount = json["likes"]["count"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

class Album {
    var id: String
    var ownerId: Int
    var date: Date
    var text: String
    var size: Int
    
    init(from realmAlbum: RealmAlbum) {
        self.id = String(realmAlbum.id)
        self.ownerId = realmAlbum.ownerId
        self.date = realmAlbum.date
        self.text = realmAlbum.text
        self.size = realmAlbum.size
    }

    internal init(id: String, ownerId: Int, date: Date, text: String, size: Int) {
        self.id = id
        self.ownerId = ownerId
        self.date = date
        self.text = text
        self.size = size
    }
}

/*
 //Загружаем альбомы
 {
     "response": {
         "count": 1,
         "items": [
             {
                 "id": 264108767,
                 "thumb_id": 457244498,
                 "owner_id": -39968672,
                 "title": "Grill Fest 2019",
                 "description": "",
                 "created": 1562038618,
                 "updated": 1562732943,
                 "size": 310,
                 "thumb_is_last": 1,
                 "can_upload": 0
             }
         ]
     }
 }
 
 //Загружаем записи со стены с типом "Альбом"
 {
     "response": {
         "count": 73,
         "items": [
             {
                 "id": 2034,
                 "from_id": -172126583,
                 "owner_id": -172126583,
                 "date": 1578466768,
 
                 "marked_as_ads": 0,
                 "post_type": "post",
                 "text": "Небольшой фотоальбом от 8 января.\nhttps://vk.com/album-172126583_272013065",
                 "attachments": [
                     {
                         "type": "album",
                         "album": {
                             "id": "272013065",
                             "thumb": {
                                 "id": 457240978,
                                 "album_id": 272013065,
                                 "owner_id": -172126583,
                                 "user_id": 100,
                                 "sizes": [
                                     {
                                         "type": "s",
                                         "url": "https://sun4-17.userapi.com/c858128/v858128327/13f8b9/NH-Ch7z3QO8.jpg",
                                         "width": 75,
                                         "height": 42
                                     },
                                     {
                                         "type": "r",
                                         "url": "https://sun4-16.userapi.com/c858128/v858128327/13f8c2/ZiBcaPGg3Sc.jpg",
                                         "width": 510,
                                         "height": 340
                                     }
                                 ],
                                 "text": "08.01.2020\nПереход с одной трибуны на другую проходит под игровым полем.",
                                 "date": 1578466432,
                                 "access_key": "8bb6004a3b09189166"
                             },
                             "owner_id": -172126583,
                             "title": "20200108",
                             "description": "",
                             "created": 1578466377,
                             "updated": 1578466432,
                             "size": 11
                         }
                     }
                 ],
                 "post_source": {
                     "type": "vk"
                 },
                 "comments": {
                     "count": 0,
                     "can_post": 1,
                     "groups_can_post": true
                 },
                 "likes": {
                     "count": 24,
                     "user_likes": 0,
                     "can_like": 1,
                     "can_publish": 1
                 },
                 "reposts": {
                     "count": 2,
                     "user_reposted": 0
                 },
                 "views": {
                     "count": 511
                 },
                 "is_favorite": false
             }
         ],
         "profiles": [],
         "groups": [
             {
                 "id": 172126583,
                 "name": "Ледовый дворец \"Байкал\", Иркутск",
                 "screen_name": "arenabaikal",
                 "is_closed": 0,
                 "type": "page",
                 "is_admin": 0,
                 "is_member": 1,
                 "is_advertiser": 0,
                 "photo_50": "https://sun4-16.userapi.com/c848620/v848620162/86272/0L2K1DXkcN4.jpg?ava=1",
                 "photo_100": "https://sun4-17.userapi.com/c848620/v848620162/86271/oaazpIZugUM.jpg?ava=1",
                 "photo_200": "https://sun4-16.userapi.com/c848620/v848620162/86270/dI6ulMBj1J8.jpg?ava=1"
             }
         ]
     }
 }
 */
