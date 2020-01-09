//
//  NewsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    /*
    public var userName = String()
    public var userPhoto = UIImage()
    let newsText = "Однажды, в студёную зимнюю пору я из лесу вышел; был сильный мороз. Гляжу, поднимается медленно в гору лошадка, везущая хворосту воз. И, шествуя важно, в спокойствии чинном, лошадку ведёт под уздцы мужичок"

    var news = [
        News("John",[UIImage(named: "John_Moto")!, UIImage(named: "John_Street")!, UIImage(named: "John_Arch")!, UIImage(named: "John_Window")!], 77 ),
        News("Helen",[UIImage(named: "Helen_Home")!, UIImage(named: "Helen_Heater")!, UIImage(named: "Helen_Bed")!, UIImage(named: "Helen_Mountains")!], 33 )
    ]
    
    var userNews = [News]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        userNews = news.filter{ $0.userName.contains(self.userName) }
        print("\(userName) News: \(userNews.count)")
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            preconditionFailure("NewsCell cannot be dequeued")
        }
        
        cell.userPhoto.image = userPhoto
        cell.userNameLabel.text = userName
        cell.newsDataLabel.text = "10.11.2019"
        cell.newsTextLabel.text = newsText
        cell.newsPhoto.image = userNews[0].newsPhoto[0]
        cell.likeCountLabel.text = String(userNews[0].likeCount)
        cell.commentCountLabel.text = String(99)
        cell.viewsCountLabel.text = String(99)
        

        return cell
    }

*/
}
