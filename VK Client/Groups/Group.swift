//
//  Group.swift
//  VK Client
//
//  Created by Maksim Romanov on 25.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

struct Group {
    let id = -1
    let my = 0
    let name = ""
    let image = ""

}

class RealmGroup: Object, Decodable {
    @objc dynamic var id = -1
    @objc dynamic var my = 0
    @objc dynamic var name = ""
    @objc dynamic var image = ""

    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.image = json["photo_100"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

/*
 {
     "response": {
         "count": 15,
         "items": [
             {
                 "id": 13695159,
                 "name": "NNM-Club",
                 "screen_name": "nnm_club",
                 "is_closed": 0,
                 "type": "group",
                 "is_admin": 0,
                 "is_member": 1,
                 "is_advertiser": 0,
                 "photo_50": "https://sun9-70.userapi.com/c5841/g13695159/e_4fe336e1.jpg?ava=1",
                 "photo_100": "https://sun9-70.userapi.com/c5841/g13695159/d_703edb3d.jpg?ava=1",
                 "photo_200": "https://sun9-70.userapi.com/c5841/g13695159/d_703edb3d.jpg?ava=1"
             },
             {
                 "id": 173826720,
                 "name": "ФИТНЕС-КЛУБ | WORLD CLASS LITE | ИРКУТСК",
                 "screen_name": "wclasslite_irk",
                 "is_closed": 0,
                 "type": "page",
                 "is_admin": 0,
                 "is_member": 1,
                 "is_advertiser": 0,
                 "photo_50": "https://sun4-15.userapi.com/c855232/v855232260/2aea1/9XPIfz4RyMA.jpg?ava=1",
                 "photo_100": "https://sun4-15.userapi.com/c855232/v855232260/2aea0/CFMtKimL_AM.jpg?ava=1",
                 "photo_200": "https://sun4-16.userapi.com/c855232/v855232260/2ae9f/QampuGjCqgg.jpg?ava=1"
             },
             {
                 "id": 58860049,
                 "name": "iOS Development Course",
                 "screen_name": "iosdevcourse",
                 "is_closed": 0,
                 "type": "group",
                 "is_admin": 0,
                 "is_member": 1,
                 "is_advertiser": 0,
                 "photo_50": "https://sun4-11.userapi.com/radQJ3FNWVDo_A0XisKaD3LL-k4C8RX56eSNWA/EczJeO0uBVg.jpg?ava=1",
                 "photo_100": "https://sun4-10.userapi.com/VN1ycBJnYVPgl5hhRPhTXpJUfc-5jYC9Zytjpg/vPdJhnsJUhI.jpg?ava=1",
                 "photo_200": "https://sun4-11.userapi.com/47yw48oIPnIv4eM05UGZUGagBqUi17GVSQgOjA/-BOrVcKWK44.jpg?ava=1"
             }
         ]
     }
 }
 */
