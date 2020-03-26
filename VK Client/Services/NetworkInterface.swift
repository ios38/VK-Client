//
//  NetworkInterface.swift
//  VK Client
//
//  Created by Maksim Romanov on 25.03.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
//import Alamofire
import PromiseKit

protocol NetworkInterface {

    func loadGroups() -> Promise<Data>
    
    func loadNews() -> Promise<Data>

    func loadNewsWithStart(startTime: Double?, startFrom: String?, completion: @escaping ([RealmNews], Data, String) -> Void)
}
