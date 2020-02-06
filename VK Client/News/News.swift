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
    @objc dynamic var attachments = ""

    @objc dynamic var imageLabel = ""
    @objc dynamic var image = ""
    @objc dynamic var aspectRatio: Float = 0

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
        self.attachments = json["attachments"][0]["type"].stringValue
        
        switch attachments {
        case "photo":
            let sizesCount = json["attachments"][0]["photo"]["sizes"].count
            self.image = json["attachments"][0]["photo"]["sizes"][sizesCount - 1]["url"].stringValue
            let width = json["attachments"][0]["photo"]["sizes"][sizesCount - 1]["width"].intValue
            let height = json["attachments"][0]["photo"]["sizes"][sizesCount - 1]["height"].intValue
            self.aspectRatio = width != 0 ? Float(height)/Float(width) : Float(0)
        case "album":
            let sizesCount = json["attachments"][0]["album"]["thumb"]["sizes"].count
            self.image = json["attachments"][0]["album"]["thumb"]["sizes"][sizesCount - 1]["url"].stringValue
        case "link":
            //let sizesCount = json["attachments"][0]["link"]["photo"]["sizes"].count
            self.image = json["attachments"][0]["link"]["photo"]["sizes"][1]["url"].stringValue
        case "video":
            if json["attachments"][0]["video"]["photo_640"].stringValue != "" {
                self.image = json["attachments"][0]["video"]["photo_640"].stringValue
            } else if json["attachments"][0]["video"]["photo_800"].stringValue != "" {
                self.image = json["attachments"][0]["video"]["photo_800"].stringValue
            }
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

/*
 {
     "response": {
         "items": [
             {
                 "can_doubt_category": false,
                 "can_set_category": false,
                 "type": "post",
                 "source_id": 181264698,
                 "date": 1579880012,
                 "post_type": "post",
                 "text": "",
                 "copy_history": [
                     {
                         "id": 506,
                         "owner_id": -179893921,
                         "from_id": -179893921,
                         "date": 1577368129,
                         "post_type": "post",
                         "text": "Хорошей музыки вам этим вечерочком!",
                         "attachments": [
                             {
                                 "type": "video",
                                 "video": {
                                     "id": 456239024,
                                     "owner_id": -179893921,
                                     "title": "Лучшее исполнение на гитаре мелодии Metallica - Nothing Else Matters",
                                     "duration": 417,
                                     "description": "Заходите на сайт http://aleztv.com/\nВсе новинки на канале!\nПодписывайся на канал и Жми палец Вверх!\n\n...не только живопись...\nНасладитесь виртуозной игрой Габриэллы!!! Приятного всем вечерочка!",
                                     "date": 1577365794,
                                     "comments": 0,
                                     "views": 23,
                                     "local_views": 23,
                                     "photo_130": "https://sun9-27.userapi.com/c627422/u279083613/video/s_4a795842.jpg",
                                     "photo_320": "https://sun9-66.userapi.com/c627422/u279083613/video/l_e96a409f.jpg",
                                     "photo_640": "https://sun9-11.userapi.com/c627422/u279083613/video/y_2cd532c2.jpg",
                                     "is_favorite": 0,
                                     "access_key": "4bb3c9ba8c11fcbc6e",
                                     "platform": "YouTube",
                                     "can_add": 1,
                                     "track_code": "video_0b327c4f5DePXdeNHBJFgZqJva2Kri0JrjIC_MQzAZ9Mq1IsvUrQF5RV2OsSGUJFLWPHmb-YHzo",
                                     "can_comment": 1,
                                     "can_repost": 1,
                                     "can_like": 1,
                                     "can_add_to_faves": 1,
                                     "can_subscribe": 1
                                 }
                             }
                         ],
                         "post_source": {
                             "type": "vk"
                         }
                     }
                 ],
                 "post_source": {
                     "type": "api",
                     "platform": "android"
                 },
                 "comments": {
                     "count": 0,
                     "can_post": 0,
                     "groups_can_post": true
                 },
                 "likes": {
                     "count": 0,
                     "user_likes": 0,
                     "can_like": 1,
                     "can_publish": 0
                 },
                 "reposts": {
                     "count": 0,
                     "user_reposted": 0
                 },
                 "views": {
                     "count": 3
                 },
                 "is_favorite": false,
                 "post_id": 624
             }
         ],
         "profiles": [
             {
                 "id": 506,
                 "first_name": "Ольга",
                 "last_name": "Рябкова",
                 "is_closed": false,
                 "can_access_closed": true,
                 "sex": 1,
                 "screen_name": "ryabkova",
                 "photo_50": "https://sun4-10.userapi.com/c855228/v855228908/320e3/MtxUg2gTgDE.jpg?ava=1",
                 "photo_100": "https://sun4-12.userapi.com/c855228/v855228908/320e2/hKn_O-OttmY.jpg?ava=1",
                 "online": 0,
                 "online_info": {
                     "visible": true,
                     "last_seen": 1579921451,
                     "app_id": 2274003,
                     "is_mobile": true
                 }
             },
             {
                 "id": 181264698,
                 "first_name": "Михаил",
                 "last_name": "Пермяков",
                 "is_closed": true,
                 "can_access_closed": true,
                 "sex": 2,
                 "screen_name": "m.permyak84",
                 "photo_50": "https://sun9-20.userapi.com/c849424/v849424981/1c0417/mv_1XNrnplw.jpg?ava=1",
                 "photo_100": "https://sun9-67.userapi.com/c849424/v849424981/1c0416/KcDRxfE5MEM.jpg?ava=1",
                 "online": 0,
                 "online_info": {
                     "visible": true,
                     "last_seen": 1579924409,
                     "app_id": 2274003,
                     "is_mobile": true
                 }
             }
         ],
         "groups": [
             {
                 "id": 179893921,
                 "name": "Мастерская Сергея Покотилова",
                 "screen_name": "club179893921",
                 "is_closed": 0,
                 "type": "group",
                 "is_admin": 0,
                 "is_member": 0,
                 "is_advertiser": 0,
                 "photo_50": "https://sun9-35.userapi.com/c856020/v856020040/1a3674/LYKETkgKjqQ.jpg?ava=1",
                 "photo_100": "https://sun9-41.userapi.com/c856020/v856020040/1a3673/0s-CHGKP9Lg.jpg?ava=1",
                 "photo_200": "https://sun9-63.userapi.com/c856020/v856020040/1a3672/_K-IXBfobDE.jpg?ava=1"
             }
         ],
         "next_from": "1/19_181264698_624:79086333"
     }
 }
 */
