//
//  News.swift
//  VK Client
//
//  Created by Maksim Romanov on 19.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class RealmNews: Object {
    @objc dynamic var id = -1
    @objc dynamic var source = -1
    @objc dynamic var date = Date.distantPast
    @objc dynamic var text = ""
    @objc dynamic var isLiked = -1
    @objc dynamic var likeCount = -1
    @objc dynamic var image = ""

    convenience init(from json: JSON) {
        self.init()
        self.id = json["post_id"].intValue
        self.source = json["source_id"].intValue
        let dateDouble = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: dateDouble)
        self.text = json["text"].stringValue
        self.isLiked = json["likes"]["user_likes"].intValue
        self.likeCount = json["likes"]["count"].intValue
        let sizesCount = json["attachments"][0]["photo"]["sizes"].count
        self.image = json["attachments"][0]["photo"]["sizes"][sizesCount - 1]["url"].stringValue
        //print("RealmNews: init: image: \(self.image)")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
