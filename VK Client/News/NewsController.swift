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

    private lazy var realmNews: Results<RealmNews> = try! RealmService.get(RealmNews.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        tableView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
        tableView.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellReuseIdentifier: "NewsTextCell")
        tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        tableView.register(UINib(nibName: "NewsControlCell", bundle: nil), forCellReuseIdentifier: "NewsControlCell")
        
        news = Array(self.realmNews).sorted(by: { $0.date > $1.date })

        loadNews(token: Session.shared.accessToken)

//        NetworkService.loadNews(token: Session.shared.accessToken) { result in
//            switch result {
//            case let .success(news):
//                try? RealmService.save(items: news)
//            case let .failure(error):
//                print(error)
//            }
//        }
//
//        self.notificationToken = realmNews.observe({ [weak self] change in
//            guard let self = self else { return }
//            switch change {
//            case .initial:
//                break
//            case .update(_, _, _, _):
//                self.news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
//                self.tableView.reloadData()
//            case let .error(error):
//                print(error)
//            }
//        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as? NewsHeaderCell else { preconditionFailure("NewsHeaderCell cannot be dequeued") }
            cell.newsImageView.kf.setImage(with: URL(string: newsSourceDetails(news[indexPath.section].source).image))
            cell.newsSourceLabel.text = newsSourceDetails(news[indexPath.section].source).name
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
    
    func newsSourceDetails(_ source: Int) -> (name: String, image: String) {
        var name = ""
        var image = ""
        if source > 0 {
            let realmNewsSource = Array(try! RealmService.get(RealmUser.self).filter("id == %@", source))
            let firstName = realmNewsSource.first?.firstName ?? ""
            let lastName = realmNewsSource.first?.lastName ?? ""
            name = lastName + " " + firstName
            image = realmNewsSource.first?.photo ?? ""
        } else {
            let realmNewsSource = Array(try! RealmService.get(RealmGroup.self).filter("id == %@", -source))
            name = realmNewsSource.first?.name ?? ""
            image = realmNewsSource.first?.image ?? ""
        }
        return (name, image)
    }
    
    func loadNews(token: String/*, completion: ((Result<[RealmNews], Error>) -> Void)? = nil*/) {
        
        let baseUrl = "https://api.vk.com"
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            //"source_ids": 13807983,
            "filters": "post",
            "count": 3,
            "extended": 1,
            "v": "5.92"
        ]
        
        let dispatchGroup = DispatchGroup()

        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
        switch response.result {
            case let .success(data):
                DispatchQueue.main.async {
                    let json = JSON(data)
                    
                    DispatchQueue.global().async(group: dispatchGroup) {
                        let newsJSONs = json["response"]["items"].arrayValue
                        let news = newsJSONs.map {RealmNews(from: $0)}
                        try? RealmService.save(items: news)
                    }
                    
                    DispatchQueue.global().async(group: dispatchGroup) {
                        let usersJSONs = json["response"]["profiles"].arrayValue
                        let users = usersJSONs.map {RealmUser(from: $0)}
                        try? RealmService.save(items: users)
                    }
                    
                    DispatchQueue.global().async(group: dispatchGroup) {
                        let groupsJSONs = json["response"]["groups"].arrayValue
                        let groups = groupsJSONs.map {RealmGroup(from: $0)}
                        try? RealmService.save(items: groups)
                    }

                    dispatchGroup.notify(queue: DispatchQueue.main) {
                        self.news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
                
    }
    
}
