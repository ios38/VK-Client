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
    var nextFrom = ""
    var nextFromUrl: URL!
    var isLoading = false
    var indexSet = IndexSet()
    var newsTextExpand = Array(repeating: false, count: 10)
    
    private lazy var realmNews: Results<RealmNews> = try! RealmService.get(RealmNews.self)

    private var dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "dd MMMM yyyy" //nsdateformatter.com
        return dt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        nextFromUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        nextFromUrl = nextFromUrl.appendingPathComponent("nextFrom.txt")
        //print("NewsController: viewDidLoad: nextFromUrl: \(String(describing: nextFromUrl))")

        tableView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
        tableView.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellReuseIdentifier: "NewsTextCell")
        //tableView.register(NewsTextWithFramesCell.self, forCellReuseIdentifier: "NewsTextWithFramesCell")
        tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        tableView.register(UINib(nibName: "NewsControlCell", bundle: nil), forCellReuseIdentifier: "NewsControlCell")
        tableView.prefetchDataSource = self
        
        news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
        newsTextExpand = Array(repeating: false, count: news.count)

        tableView.tableHeaderView = newsTableHeader
        print("NewsController: viewDidLoad: sources.count: \(newsSources(news).count)")
        newsTableHeader.sources = newsSources(news)
        //tableView.tableHeaderView?.backgroundColor = .darkGray
        do {
            nextFrom = try String(contentsOf: nextFromUrl)
        } catch {
            print(error)
        }
        //print("NewsController: viewDidLoad: nextFrom: \(nextFrom)")

        NetworkService
            .loadNews()
//            .map(on: DispatchQueue.global()) { data in
//                self.newsData(data)
            .done(on: DispatchQueue.global()) { data in
                self.newsData(data)
            }.catch { error in
                self.show(error: error)
            }
        
        setupRefreshControl()
                
        self.notificationToken = realmNews.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                let newsCountBeforeUpdate = self.news.count
                self.news = Array(self.realmNews).sorted(by: { $0.date > $1.date })
                self.indexSet = IndexSet(integersIn: newsCountBeforeUpdate..<self.news.count)
                print("NewsController: notificationToken: indexSet: \(self.indexSet)")
                //print("NewsController: notificationToken: sources.count: \(self.newsSources(self.news).count)")
                self.newsTableHeader.sources = self.newsSources(self.news)
                //self.tableView.reloadData()
                let newsTextExpand = Array(repeating: false, count: self.indexSet.count)
                self.newsTextExpand += newsTextExpand
                self.tableView.insertSections(self.indexSet, with: .automatic)
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
            cell.newsDateLabel.text = dateFormatter.string(from: (Date(timeIntervalSince1970: news[indexPath.section].date)))
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell else { preconditionFailure("NewsTextCell cannot be dequeued") }
            cell.newsTextLabel.text = news[indexPath.section].text
            cell.expandImage.isHidden = hideExpandIcon(section: indexPath.section, height: cell.bounds.height)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let insets: CGFloat = 10
        let fitSize = newsTextFitSize(indexPath.section)
        switch indexPath.row {
        case 1:
            switch newsTextExpand[indexPath.section] {
            case true:
                return fitSize + insets
            case false:
                if fitSize < 150 {
                    return fitSize + insets
                } else {
                    return 150
                }
            }
        case 2:
            let aspectRatio = CGFloat(news[indexPath.section].aspectRatio)
            return aspectRatio * tableView.bounds.width
        default:
            return UITableView.automaticDimension
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
                self.nextFrom = try self.parsingService.parsingNextFrom(data)
                try self.nextFrom.write(to: self.nextFromUrl, atomically: true, encoding: .utf8)
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
        switch indexPath.row {
        case 0, 2:
            performSegue(withIdentifier: "ShowNewsDetails", sender: nil)
        case 1:
            newsTextExpand[indexPath.section].toggle()
            tableView.reloadData()
        default:
            return
        }
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
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .systemGray
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing News...")
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }

    @objc private func refreshNews() {
        print("NewsController: Refresh News triggered")
        let startTime = news.first?.date ?? Date().timeIntervalSince1970
        NetworkService.loadNewsWithStart(startTime: startTime + 1) { news, data, _ in
            print ("NewsController: refreshNews: news: \(news.count)")
            self.newsData(data)
            self.refreshControl?.endRefreshing()
        }
    }

    func newsTextFitSize(_ section: Int) -> CGFloat {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = textLabel.font.withSize(14)
        textLabel.text = news[section].text
        let maxSize: CGSize = CGSize(width: tableView.bounds.width - 20, height: 9999)
        let fitSize: CGSize = textLabel.sizeThatFits(maxSize)
        //print("NewsController: newsTextFitSize heigth for section \(section): \(fitSize.height) ")
        return fitSize.height
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func hideExpandIcon(section: Int, height: CGFloat) -> Bool {
        let insets: CGFloat = 10
        guard height - insets < newsTextFitSize(section) else { return true }
        switch newsTextExpand[section] {
        case true:
            return true
        case false:
            return false
        }
    }

}

extension NewsController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > news.count - 2, !isLoading {
            //print ("NewsController: DataSourcePrefetching: *** started ***")
            isLoading = true
            NetworkService.loadNewsWithStart(startFrom: nextFrom) { news, data, nextFrom in
                print ("NewsController: DataSourcePrefetching: result: \(news.count)")
                //print ("NewsController: DataSourcePrefetching: nextFrom: \(nextFrom)")
                self.newsData(data)
                self.nextFrom = nextFrom
                self.refreshControl?.endRefreshing()
                self.isLoading = false
            }
        }
    }
}
