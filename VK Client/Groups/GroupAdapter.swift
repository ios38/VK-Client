//
//  GroupAdapter.swift
//  VK Client
//
//  Created by Maksim Romanov on 04.03.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import RealmSwift

class GroupAdapter {
    private var notificationToken: NotificationToken?

    func getGroup(completion: @escaping ([Group]) -> Void) {
        guard let realm = try? Realm(),
            let realmGroups = realm.object(ofType: RealmGroup.self, forPrimaryKey: )
        else { return }
        
    }
}
