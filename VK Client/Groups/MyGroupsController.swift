//
//  MyGroupsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 25.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }

    private var notificationToken: NotificationToken?
    //private let networkService = NetworkService()
    var groups = [RealmGroup]()
    var currentGroups = [RealmGroup]()
    var globalGroups = [RealmGroup]()

    private lazy var realmGroups: Results<RealmGroup> = try! RealmService.get(RealmGroup.self)

    
    struct groupCategory {
        let name: String
        var items: [RealmGroup]
    }
    
    var sections = [groupCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(false, animated: true)
        overrideUserInterfaceStyle = .dark
        tableView.register(UINib(nibName: "GroupCellXib", bundle: nil), forCellReuseIdentifier: "GroupCellXib")
        
        groups = Array(realmGroups)
        currentGroups = groups
        
        sections = [
            groupCategory(name: "", items: currentGroups),
            groupCategory(name: "Глобальный поиск", items: globalGroups)
        ]
        /*
        NetworkService.loadGroups() { /*[weak self]*/ result in
            //quard let self = self else {return}
            switch result {
            case let .success(groups):
                try? RealmService.save(items: groups)
            case let .failure(error):
                print(error)
            }
        }*/
        
        NetworkService
            .loadGroups()
            .done { groups in
                try? RealmService.save(items: groups)
            }.catch { error in
                self.show(error: error)
            }

        self.notificationToken = realmGroups.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                self.searchBar(self.searchBar, textDidChange: self.searchBar.text ?? "")
            case let .error(error):
                print(error)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        if sections[1].items.isEmpty {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = sections[section].items
        return items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCellXib", for: indexPath) as? GroupCellXib else {
            preconditionFailure("GroupCellXib cannot be dequeued")
        }
        let items = self.sections[indexPath.section].items
        let item = items[indexPath.row]
        cell.configure(with: item)

        return cell
    }
        //Удаление группы
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete, indexPath.section == 0 else { return }
                let group = currentGroups[indexPath.row]
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.delete(group)
                    }
                } catch {
                    print(error)
                }
        }
        
    //Добавление группы из AllGroupsController
    @IBAction func addGroup(unwindSegue: UIStoryboardSegue) {
        
        if let sourseController = unwindSegue.source as? AllGroupsController,
            let indexPath = sourseController.tableView.indexPathForSelectedRow {
            let group = sourseController.groups[indexPath.row]
            if !groups.contains(where: {$0.id == group.id}) {
                groups.append(group)
                try? RealmService.save(items: groups, configuration: RealmService.deleteIfMigration, update: .all)
                self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
            }
        }
    }

    //Обработка выбора группы:
    //из секции 0 (группы пользователя): переход к новостям группы
    //из секции 1 (глобальный поиск): добавление группы
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //guard indexPath.section == 1 else { return }
        let group = sections[indexPath.section].items[indexPath.row]
        switch indexPath.section {
        case 0:
            self.performSegue(withIdentifier: "Show Albums", sender: nil)
        case 1:
            if !groups.contains(where: {$0.id == group.id}) {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(group)
                    }
                    print("Добавили \(group.name) в Realm")
                } catch {
                    print(error)
                }
            }
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Albums",
            let destination = segue.destination as? AlbumsController,
            let indexPath = tableView.indexPathForSelectedRow {
            //Выбираем группу для передачи
            guard indexPath.section == 0 else { return }
            let group = sections[indexPath.section].items[indexPath.row]
            //Передаем id друга
            destination.ownerId = -group.id
        }
    }

    //Локальный и глобальный поиск групп
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //print ("Очистка секции 'Глобальный поиск'")
        sections[1].items.removeAll()
        //self.globalGroups.removeAll()

        
        if searchText.isEmpty {
            groups = Array(realmGroups)
            currentGroups = groups
            sections[0].items = currentGroups
            self.tableView.reloadData()
        } else {
            groups = Array(realmGroups)
            currentGroups = groups.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            sections[0].items = currentGroups
            
            NetworkService.searchGroups(token: Session.shared.accessToken, searchText: searchText.lowercased()) { /*[weak self]*/ result in
                //quard let self = self else {return}
                switch result {
                case let .success(groups):
                    
                    for group in groups {
                        if !self.groups.contains(where: {$0.id == group.id}){
                            self.globalGroups.append(group)
                        } else {
                            print ("Группа \(group.name) уже есть")
                        }
                    }
                    
                    self.sections[1].items = self.globalGroups
                    //print ("globalGroups.count = \(self.globalGroups.count)")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        //print ("Очистка globalGroups")
                        self.globalGroups.removeAll()
                    }

                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }

}
