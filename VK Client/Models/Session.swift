//
//  Session.swift
//  VK Client
//
//  Created by Maksim Romanov on 04.12.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import Foundation

class Session {
    private init() {}
    
    public static let shared = Session()
    
    var accessToken = ""
    
}
