//
//  AlbumsController.swift
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
    private let parsingService = ParsingService()

    public var ownerId = Int()
    var albumId = String()
    
    private var dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "dd MMMM yyyy" //nsdateformatter.com
        return dt
    }()

    var albums = [RealmAlbum]()
    var owner = [RealmGroup]()
    
    private lazy var realmAlbums: Results<RealmAlbum> = try! RealmService.get(RealmAlbum.self).filter("ownerId == %@", ownerId)
    private lazy var realmOwner: Results<RealmGroup> = try! RealmService.get(RealmGroup.self).filter("id == %@", -ownerId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        tableView.register(UINib(nibName: "AlbumsCell", bundle: nil), forCellReuseIdentifier: "AlbumsCell")
        albums = Array(self.realmAlbums)
        owner = Array(self.realmOwner)
        
        NetworkService
            .loadAlbums(owner: ownerId)
            .map(on: DispatchQueue.global()) { data in
                try self.parsingService.parsingAlbums(data)
            }.done { albums in
                try? RealmService.save(items: albums)
            }.catch { error in
                self.show(error: error)
            }
        /*
        NetworkService.loadAlbums(owner: ownerId) { result in
            switch result {
            case let .success(albums):
                try? RealmService.save(items: albums)
            case let .failure(error):
                print(error)
            }
        }*/
        
        self.notificationToken = realmAlbums.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                self.albums = Array(self.realmAlbums)
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
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
        cell.albumDateLabel.text = dateFormatter.string(from: (albums[indexPath.section].date))
        cell.albumTextLabel.text = albums[indexPath.section].text
        cell.updateCellWith(owner: albums[indexPath.section].ownerId, album: String(albums[indexPath.section].id))
        
        return cell
    }
    
    deinit {
        notificationToken?.invalidate()
    }

}
