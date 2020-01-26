//
//  ParsingService.swift
//  VK Client
//
//  Created by Maksim Romanov on 24.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParsingService {
    
    func parsingPhoto(data: Any) -> [RealmPhoto] {
        let json = JSON(data)
        let photosJSONs = json["response"]["items"].arrayValue
        let photos = photosJSONs.map {RealmPhoto(from: $0)}
        return photos
    }

}
