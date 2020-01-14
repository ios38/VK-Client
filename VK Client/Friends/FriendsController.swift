//
//  MyFriendsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 26.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsController: UITableViewController {
    private var notificationToken: NotificationToken?
    private let networkSrvice = NetworkService()
    private lazy var friends: Results<RealmUser> = try! RealmService.get(RealmUser.self)
    private var sortedFriends = [Character: [RealmUser]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        sortedFriends = self.sort(friends: friends)

        NetworkService.loadFriends(token: Session.shared.accessToken) { /*[weak self]*/ result in
            //quard let self = self else { return }
            switch result {
            case let .success(friends):
                try? RealmService.save(items: friends)
                print("FriendsController: viewDidLoad: friends saved to Realm")
            case let .failure(error):
                print(error)
            }
        }
        
        self.notificationToken = friends.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case let .update(results, deletions, insertions, modifications):
                self.sortedFriends = self.sort(friends: self.friends)
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })
        
    }
    
    private func sort(friends: Results<RealmUser>) -> [Character: [RealmUser]] {
        var friendDict = [Character: [RealmUser]]()

        friends.forEach {friend in
            guard let firstChar = friend.lastName.first else { return }
            if var thisCharFriends = friendDict[firstChar] {
                thisCharFriends.append(friend)
                //print(thisCharFriends)
                friendDict[firstChar] = thisCharFriends
            } else {
                friendDict[firstChar] = [friend]
            }
        }
        
        return friendDict
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedFriends.keys.count
        //return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let keysSorted = sortedFriends.keys.sorted()
        return sortedFriends[keysSorted[section]]?.count ?? 0
        //return friends.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstChar = sortedFriends.keys.sorted()[section]
        return String(firstChar)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as? FriendCell else {
            preconditionFailure("MyFriendsCell cannot be dequeued")
        }
        
        let firstChar = sortedFriends.keys.sorted()[indexPath.section]
        let friends = sortedFriends[firstChar]!
        let friend: RealmUser = friends[indexPath.row]
        cell.configure(with: friend)
                
        return cell
    }
    
    //Удаление друга и его фото
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let firstChar = sortedFriends.keys.sorted()[indexPath.section]
            let friends = sortedFriends[firstChar]!
            let friend = friends[indexPath.row]
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(realm.objects(RealmPhoto.self).filter("ownerId == %@", friend.id))
                    realm.delete(friend)
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Photos",
            let destination = segue.destination as? PhotosController,
            let indexPath = tableView.indexPathForSelectedRow {
            //Выбираем друга для передачи
            let firstChar = sortedFriends.keys.sorted()[indexPath.section]
            let friends = sortedFriends[firstChar]!
            let friend = friends[indexPath.row]
            //Передаем id друга
            destination.ownerId = friend.id
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

}
