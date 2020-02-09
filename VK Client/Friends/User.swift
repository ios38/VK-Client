//
//  User.swift
//  VK Client
//
//  Created by Maksim Romanov on 28.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class RealmUser: Object {
    @objc dynamic var id = -1
    @objc dynamic var my = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo = ""
    //@objc dynamic var online = -1

    let photos = List<RealmPhoto>()

    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo_100"].stringValue
        //self.online = json["online"].intValue

        //self.photos.append(objectsIn: photos)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

/*
{
    "response": {
        "count": 4,
        "items": [
            {
                "id": 13807983,
                "first_name": "Оксана",
                "last_name": "Романова",
                "is_closed": false,
                "can_access_closed": true,
                "photo_200": "https://sun9-46.userapi.com/c840424/v840424780/738da/37swve3yXN8.jpg?ava=1",
                "online": 0,
                "lists": [
                    29
                ],
                "track_code": "8a32d587_V8DL8c9lFGsPLEp5LO06QNSHCCIMYovQFbUraNwtWOMI1kkrT6aDv1msZc5FAPcLQ1Weusyjy50X88"
            },
        ]
    }
}*/
