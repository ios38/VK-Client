//
//  AllGroupsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 25.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class AllGroupsController: UIViewController, UISearchBarDelegate{
    var groups = [RealmGroup]()
    //private let networkSrvice = NetworkService()


    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupCellXib", bundle: nil), forCellReuseIdentifier: "GroupCellXib")
    }
}

extension AllGroupsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCellXib", for: indexPath) as? GroupCellXib else {
            preconditionFailure("GroupCellXib cannot be dequeued")
        }
        
        let group: RealmGroup = groups[indexPath.row]
        cell.configure(with: group)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Row selected: \(indexPath.row)")
        performSegue(withIdentifier: "Add Group", sender: nil)
    }
    
    //Ищем группы
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        if searchText.isEmpty {
            NetworkService.searchGroups(token: Session.shared.accessToken, searchText: "")
        } else {
            NetworkService.searchGroups(token: Session.shared.accessToken, searchText: searchText.lowercased()) { /*[weak self]*/ result in
                //quard let self = self else {return}
                switch result {
                case let .success(groups):
                    self.groups = groups
                    //print("AllGroupsController: searchGroups: \(self.groups)")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
        tableView.reloadData()        
    }

}
