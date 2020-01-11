//
//  RealmService.swift
//  VK Client
//
//  Created by Maksim Romanov on 21.12.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save<T: Object>(items: [T],
        configuration: Realm.Configuration = deleteIfMigration,
        update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configuration)
        //print(configuration.fileURL ?? "")
        try realm.write {
            realm.add(items, update: update)
        }
    }
    /*
    static func delete<T: Object>(items: [T],
        configuration: Realm.Configuration = deleteIfMigration,
        update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        try realm.write {
            realm.delete(items)
        }
    }*/

}
