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
        //print("\(items)")
        try realm.write {
            realm.add(items, update: update)
            //print("RealmService: saved \(items.count) items")
        }
    }
    //https://realm.io/docs/cookbook/swift/object-to-background/
    func saveAsync<T : ThreadConfined>(obj: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
        let wrappedObj = ThreadSafeReference(to: obj)
        let configuration = RealmService.deleteIfMigration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: configuration)
                    let obj = realm.resolve(wrappedObj)

                    try realm.write {
                        block(realm, obj)
                    }
                }
                catch {
                    errorHandler(error)
                }
            }
        }
    }

    static func get<T: Object>(
        _ type: T.Type,
        configuration: Realm.Configuration = deleteIfMigration
    ) throws -> Results<T> {
        let realm = try Realm(configuration: configuration)
        return realm.objects(type)
    }
    
    static func delete<T: Object>(
        _ object: T,
        configuration: Realm.Configuration = deleteIfMigration
    ) throws {
        let realm = try Realm(configuration: configuration)
        try realm.write {
            realm.delete(object)
        }
    }

}
