//
//  NewsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class AlbumsController: UITableViewController {
    private var notificationToken: NotificationToken?
    public var ownerId = Int()
    var albumId = Int()
    
    private var dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "dd MMMM yyyy" //nsdateformatter.com
        return dt
    }()

    var news = [RealmAlbums]()
    var owner = [RealmGroup]()
    
    private lazy var realmAlbums: Results<RealmAlbums> = try! RealmService.get(RealmAlbums.self).filter("ownerId == %@", ownerId)
    private lazy var realmOwner: Results<RealmGroup> = try! RealmService.get(RealmGroup.self).filter("id == %@", -ownerId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        tableView.register(UINib(nibName: "AlbumsCell", bundle: nil), forCellReuseIdentifier: "AlbumsCell")
        news = Array(self.realmAlbums)
        owner = Array(self.realmOwner)

        NetworkService.loadAlbums(token: Session.shared.accessToken, owner: ownerId) { result in
            switch result {
            case let .success(news):
                try? RealmService.save(items: news)
            case let .failure(error):
                print(error)
            }
        }
        
        self.notificationToken = realmAlbums.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                self.news = Array(self.realmAlbums)
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as? AlbumsCell else {
            preconditionFailure("AlbumsCell cannot be dequeued")
        }
        
        cell.ownerImageView.kf.setImage(with: URL(string: owner.first?.image ?? ""))
        cell.ownerNameLabel.text = String(owner.first?.name ?? "")
        cell.newsDataLabel.text = dateFormatter.string(from: (news[indexPath.section].date))
        cell.newsTextLabel.text = news[indexPath.section].text
        cell.updateCellWith(owner: news[indexPath.section].ownerId, album: news[indexPath.section].id)
        
        return cell
    }
    
    deinit {
        notificationToken?.invalidate()
    }

}
