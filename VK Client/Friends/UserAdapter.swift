//
//  UserAdapter.swift
//  VK Client
//
//  Created by Maksim Romanov on 04.03.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import RealmSwift

class UserAdapter {
    private var notificationToken: NotificationToken?
    private let parsingService = ParsingService()
    private lazy var realmUsers: Results<RealmUser> = try! RealmService.get(RealmUser.self).filter("my == 1")
    var users = [User]()

    func getUsers(completion: @escaping ([User]) -> Void) {
        self.notificationToken?.invalidate()

        for realmUser in self.realmUsers {
            self.users.append(self.user(from: realmUser))
        }
        completion(self.users)

        NetworkService
            .loadFriends()
            .map(on: DispatchQueue.global()) { data in
                try self.parsingService.parsingFriends(data)
            }.done { friends in
                try? RealmService.save(items: friends)
            }.catch { error in
                print(error)
            }

        self.notificationToken = realmUsers.observe({ [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                break
            case .update(_, _, _, _):
                self.users = [User]()
                for realmUser in self.realmUsers {
                    self.users.append(self.user(from: realmUser))
                }
                completion(self.users)
            case let .error(error):
                print(error)
            }
        })
    }
    
    private func user(from realmUser: RealmUser) -> User {
        return User(
            id: realmUser.id,
            my: realmUser.my,
            firstName: realmUser.firstName,
            lastName: realmUser.lastName,
            photo: realmUser.photo
        )
    }

}
