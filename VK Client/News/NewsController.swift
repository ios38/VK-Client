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
import PromiseKit
import Kingfisher

class NewsController: UITableViewController {
    private var notificationToken: NotificationToken?
    private let parsingService = ParsingService()
    var news = [RealmNews]()
    var newsSources = [NewsSource]()
    var newsTableHeader = NewsTableHeader()

    private lazy var realmNews: Results<RealmNews> = try! RealmService.get(RealmNews.self)

    private var dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "dd MMMM yyyy" //nsdateformatter.com
        return dt
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        tableView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
        tableView.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellReuseIdentifier: "NewsTextCell")
        tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        tableView.register(UINib(nibName: "NewsControlCell", bundle: nil), forCellReuseIdentifier: "NewsControlCell")

        news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
        tableView.tableHeaderView = newsTableHeader
        print("NewsController: viewDidLoad: sources.count: \(newsSources(news).count)")
        newsTableHeader.sources = newsSources(news)
        //tableView.tableHeaderView?.backgroundColor = .darkGray

        NetworkService
            .loadNews()
//            .map(on: DispatchQueue.global()) { data in
//                self.newsData(data)
            .done(on: DispatchQueue.global()) { data in
                self.newsData(data)
            }.catch { error in
                self.show(error: error)
            }

        self.notificationToken = realmNews.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                self.news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
                print("NewsController: notificationToken: sources.count: \(self.newsSources(self.news).count)")
                self.newsTableHeader.sources = self.newsSources(self.news)
                self.tableView.reloadData()
                self.newsTableHeader.collectionView.reloadData()
            case let .error(error):
                print(error)
            }
        })
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
            cell.newsImageLabel.text = news[indexPath.section].imageLabel
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
    
    func newsData(_ data: Data) {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global().async(group: dispatchGroup) {
            do {
                let news = try self.parsingService.parsingNews(data)
                try? RealmService.save(items: news)
            } catch {
                print(error)
            }
        }

        DispatchQueue.global().async(group: dispatchGroup) {
            do {
                let items = try self.parsingService.parsingProfiles(data)
                try? RealmService.save(items: items)
            } catch {
                print(error)
            }
        }
        
        DispatchQueue.global().async(group: dispatchGroup) {
            do {
                let items = try self.parsingService.parsingNewsGroups(data)
                try? RealmService.save(items: items)
            } catch {
                print(error)
            }
        }
        /*
        dispatchGroup.notify(queue: DispatchQueue.main) {
        }*/
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("NewsController: News selected: \(indexPath.section)")
        performSegue(withIdentifier: "ShowNewsDetails", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewsDetails",
            let destination = segue.destination as? NewsDetailsController,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.newsId = news[indexPath.section].id
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //tableView.tableHeaderView!.frame.size.height = 100
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }

    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = 60
    }

    func newsSources(_ news: [RealmNews]) -> [NewsSource]{
        var sources = [NewsSource]()
        news.forEach {
            let newsSource = $0.source
            if !sources.contains(where: { $0.id == newsSource} ) {
                sources.append(NewsSource(
                    id: $0.source,
                    name: newsSourceDetails($0.source).name,
                    image: newsSourceDetails($0.source).image
            ))}
        }
        return sources
    }
    /*
    func newsSourcesDict(_ news: [RealmNews]) -> [Int: String] {
        var newsSourcesDict = [Int: String]()
        news.forEach {
            newsSourcesDict[$0.source] = $0.image
        }
        return newsSourcesDict
    }*/

    deinit {
        notificationToken?.invalidate()
    }

}
