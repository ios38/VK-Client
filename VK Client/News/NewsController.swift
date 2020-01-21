//
//  NewsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 18.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Kingfisher

class NewsController: UITableViewController {
    private var notificationToken: NotificationToken?

    private var dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "dd MMMM yyyy" //nsdateformatter.com
        return dt
    }()

    var news = [RealmNews]()
//    var users = [RealmUser]()
//    var newsItems = [RealmNews]()
//    var newsUsers = [RealmUser]()

    private lazy var realmNews: Results<RealmNews> = try! RealmService.get(RealmNews.self)


    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        tableView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
        tableView.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellReuseIdentifier: "NewsTextCell")
        tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        tableView.register(UINib(nibName: "NewsControlCell", bundle: nil), forCellReuseIdentifier: "NewsControlCell")
        
        news = Array(self.realmNews).sorted(by: { $0.date > $1.date })

        //loadNews(token: Session.shared.accessToken)

        NetworkService.loadNews(token: Session.shared.accessToken) { result in
            switch result {
            case let .success(news):
                try? RealmService.save(items: news)
            case let .failure(error):
                print(error)
            }
        }

        self.notificationToken = realmNews.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                self.news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as? NewsHeaderCell else { preconditionFailure("NewsHeaderCell cannot be dequeued") }
            cell.newsSourceLabel.text = "News source id: " + String(news[indexPath.section].source)
            cell.newsDateLabel.text = dateFormatter.string(from: (news[indexPath.section].date))
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell else { preconditionFailure("NewsTextCell cannot be dequeued") }
            cell.newsTextLabel.text = news[indexPath.section].text
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as? NewsImageCell else { preconditionFailure("NewsImageCell cannot be dequeued") }
            cell.newsImageView.kf.setImage(with: URL(string: news[indexPath.section].image))
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsControlCell", for: indexPath) as? NewsControlCell else { preconditionFailure("NewsControlCell cannot be dequeued") }
            let item = news[indexPath.section]
            cell.configure(with: item)

            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    /*
    func loadNews(token: String/*, completion: ((Result<[RealmNews], Error>) -> Void)? = nil*/) {
        
        let baseUrl = "https://api.vk.com"
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "source_ids": -15365973,
            //"filters": "post",
            "count": 3,
            "extended": 1,
            "v": "5.92"
        ]
        
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "ru.mr-vk-client.news-queue", attributes: .concurrent)

        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: queue, completionHandler: { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let newsJSONs = json["response"]["items"].arrayValue
                print("NewsController: loadNews: session.request: news.count: \(newsJSONs.count)")
                //let usersJSONs = json["response"]["profiles"].arrayValue
                
                //completion?(.success(news))
            case let .failure(error):
                print(error)
                //completion?(.failure (error))
            }
        })
                
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("all tasks in the group are completed")
            print("NewsController: loadNews: dispatchGroup.notify: news.count: \(self.news.count)")
            print("NewsController: loadNews: dispatchGroup.notify: users.count: \(self.users.count)")
            self.news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
            self.tableView.reloadData()

        }
        
    }*/
    
}

/*
DispatchQueue.global().async(group: dispatchGroup) {
    let news = newsJSONs.map {RealmNews(from: $0)}
    try? RealmService.save(items: news)
    print("NewsController: loadNews: session.request: news.count: \(news.count)")
}

DispatchQueue.global().async(group: dispatchGroup) {
    self.users = usersJSONs.map {RealmUser(from: $0)}
    //try? RealmService.save(items: news)
    print("NewsController: loadNews: session.request: users.count: \(self.users.count)")
}
*/


/*
DispatchQueue.global().async(group: dispatchGroup) {
    NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
        switch response.result {
        case let .success(data):
            let json = JSON(data)
            let usersJSONs = json["response"]["profiles"].arrayValue
            //print(usersJSONs)
            self.newsUsers = usersJSONs.map {RealmUser(from: $0)}
            print("NewsController: loadNews: users.count: \(self.newsUsers.count)")
            //print(self.newsUsers)
            //completion?(.success(users))
        case let .failure(error):
            print(error)
            //completion?(.failure (error))
        }
    }
}*/

/*
func printNews () {
    print("NewsController: printNews: \(self.newsUsers)")

}*/
