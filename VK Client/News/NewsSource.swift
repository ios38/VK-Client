//
//  NewsSource.swift
//  VK Client
//
//  Created by Maksim Romanov on 04.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation

class NewsSource {
    var id: Int
    var name: String
    var image: String

    internal init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
