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
    
    @objc dynamic var imageLabel = ""
    @objc dynamic var image = ""

    @objc dynamic var isLiked = -1
    @objc dynamic var likeCount = -1
    @objc dynamic var commentsCount = -1
    @objc dynamic var repostsCount = -1
    @objc dynamic var viewsCount = -1
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["post_id"].intValue
        self.source = json["source_id"].intValue
        let dateDouble = json["date"].doubleValue
        self.date = Date(timeIntervalSince1970: dateDouble)
        self.text = json["text"].stringValue
        
        switch json["attachments"][0]["type"].stringValue {
        case "photo":
            let sizesCount = json["attachments"][0]["photo"]["sizes"].count
            self.image = json["attachments"][0]["photo"]["sizes"][sizesCount - 1]["url"].stringValue
        case "album":
            let sizesCount = json["attachments"][0]["album"]["thumb"]["sizes"].count
            self.image = json["attachments"][0]["album"]["thumb"]["sizes"][sizesCount - 1]["url"].stringValue
        default:
            self.imageLabel = "Attachment type '\(json["attachments"][0]["type"].stringValue)' is not supported now 🙁\n Parsing of this type will appear later"
        }
        
        self.isLiked = json["likes"]["user_likes"].intValue
        self.likeCount = json["likes"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue

    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
