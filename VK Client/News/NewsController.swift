//
//  NewsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    public var ownerId = Int()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        print("NewsController: ownerId: \(ownerId)")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //news.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->  CGFloat {
        return 500
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            preconditionFailure("NewsCell cannot be dequeued")
        }
        /*
        cell.userPhoto.image = userPhoto
        cell.userNameLabel.text = userName
        cell.newsDataLabel.text = "10.11.2019"
        cell.newsTextLabel.text = newsText
        cell.newsPhoto.image = userNews[0].newsPhoto[0]
        cell.likeCountLabel.text = String(userNews[0].likeCount)
        cell.commentCountLabel.text = String(99)
        cell.viewsCountLabel.text = String(99)
        */

        return cell
    }

}
