//
//  NetworkProxy.swift
//  VK Client
//
//  Created by Maksim Romanov on 25.03.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkProxy: NetworkInterface {
    let networkService: NetworkInterface
    init(networkService: NetworkInterface) {
        self.networkService = networkService
    }
    
    func loadGroups() -> Promise<Data> {
        print("Loading groups via NetworkProxy")
        return networkService.loadGroups()
    }

    func loadNews() -> Promise<Data> {
        print("Loading news via NetworkProxy")
        return networkService.loadNews()
    }

    func loadNewsWithStart(startTime: Double?, startFrom: String?, completion: @escaping ([RealmNews], Data, String) -> Void) {
        print("Loading loadNewsWithStart via NetworkProxy")
        return networkService.loadNewsWithStart(startTime: startTime, startFrom: startFrom, completion: completion)
    }
}
