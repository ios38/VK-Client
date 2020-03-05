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
    //private var notificationToken: NotificationToken?
    //private let parsingService = ParsingService()

    //private lazy var friends: Results<RealmUser> = try! RealmService.get(RealmUser.self).filter("my == 1")
    //private var sortedFriends = [Character: [RealmUser]]()

    private let userAdapter = UserAdapter()
    private var friends = [User]()
    //private var sortedFriends = [Character: [User]]()
    private var sortedFriends = [Character: [UserViewModel]]()
    private let friendViewModelFactory = UserViewModelFactory()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        userAdapter.getUsers() { [weak self] users in
            guard let self = self else { return }
            let friendViewModels = self.friendViewModelFactory.constructViewModels(from: users)
            //self.sortedFriends = self.sort(friends: users)
            self.sortedFriends = self.sort(friends: friendViewModels)
            self.tableView.reloadData()
        }

        //sortedFriends = self.sort(friends: friends)
        
        /*
        NetworkService
            .loadFriends()
            .map(on: DispatchQueue.global()) { data in
                try self.parsingService.parsingFriends(data)
            }.done { friends in
                try? RealmService.save(items: friends)
            }.catch { error in
                self.show(error: error)
            }

        self.notificationToken = friends.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                self.sortedFriends = self.sort(friends: self.friends)
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })*/
        
    }
    
    //private func sort(friends: Results<RealmUser>) -> [Character: [RealmUser]] {
    //private func sort(friends: [User]) -> [Character: [User]] {
    private func sort(friends: [UserViewModel]) -> [Character: [UserViewModel]] {
        //var friendDict = [Character: [RealmUser]]()
        var friendDict = [Character: [UserViewModel]]()

        friends.forEach {friend in
            //guard let firstChar = friend.lastName.first else { return }
            guard let firstChar = friend.name.first else { return }
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
        let friend = friends[indexPath.row]
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
                    //realm.delete(friend)
                    realm.delete(realm.objects(RealmUser.self).filter("id == %@", friend.id))
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
        //Выбираем друга для передачи
        let firstChar = sortedFriends.keys.sorted()[indexPath.section]
        let friends = sortedFriends[firstChar]!
        let friend = friends[indexPath.row]
        //Передаем id друга
        let albumsVC = AlbumsASController(ownerId: friend.id)
        //newsVC.modalTransitionStyle = .crossDissolve
        //newsVC.modalPresentationStyle = .overFullScreen
        //present(newsVC, animated: false)
        navigationController?.pushViewController(albumsVC, animated: true)
        }
    }
    /*
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
    }*/
    /*
    deinit {
        notificationToken?.invalidate()
    }*/

}
