//
//  NewsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift

class NewsController: UITableViewController {
    private var notificationToken: NotificationToken?
    public var ownerId = Int()
    var news = [RealmNews]()
    private lazy var realmNews: Results<RealmNews> = try! Realm(configuration: RealmService.deleteIfMigration).objects(RealmNews.self).filter("ownerId == %@", ownerId)
            
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        //print("NewsController: ownerId: \(ownerId)")
        //print("NewsController: realmNews: \(realmNews)")
        news = Array(self.realmNews)
        
        NetworkService.loadNews(token: Session.shared.accessToken, owner: ownerId) { result in
            switch result {
            case let .success(news):
                try? RealmService.save(items: news, configuration: RealmService.deleteIfMigration, update: .all)
            case let .failure(error):
                print(error)
            }
        }
        
        self.notificationToken = realmNews.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case let .update(results, deletions, insertions, modifications):
                self.news = Array(self.realmNews)
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
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->  CGFloat {
        return 300
    }*/

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            preconditionFailure("NewsCell cannot be dequeued")
        }
        
        //cell.userPhoto.image = userPhoto
        cell.userNameLabel.text = String(news[indexPath.section].ownerId)
        cell.newsDataLabel.text = String(news[indexPath.section].albumId)
        cell.newsTextLabel.text = news[indexPath.section].text
        //cell.newsPhoto.image = userNews[0].newsPhoto[0]
        cell.likeCountLabel.text = String(news[indexPath.section].likeCount)
        //cell.commentCountLabel.text = String(99)
        //cell.viewsCountLabel.text = String(99)
        //cell.ownerId = news[indexPath.section].ownerId
        //cell.albumId = news[indexPath.section].albumId
        saveAlbumToRealm(ownerId: news[indexPath.section].ownerId, albumId: news[indexPath.section].albumId)
        cell.updateCellWith(owner: news[indexPath.section].ownerId, album: news[indexPath.section].albumId)
        
        return cell
    }
    
    func saveAlbumToRealm (ownerId: Int, albumId: Int) {

        NetworkService.loadPhotos(token: Session.shared.accessToken, owner: ownerId, album: albumId) { result in
            switch result {
            case let .success(photos):
                print("saveAlbumToRealm: owner: \(ownerId), album: \(albumId), photos: \(photos.count)")
                try? RealmService.save(items: photos, configuration: RealmService.deleteIfMigration, update: .all)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }

}
