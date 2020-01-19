//
//  NewsController.swift
//  VK Client
//
//  Created by Maksim Romanov on 18.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        tableView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
        tableView.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellReuseIdentifier: "NewsTextCell")
        tableView.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellReuseIdentifier: "NewsImageCell")
        tableView.register(UINib(nibName: "NewsControlCell", bundle: nil), forCellReuseIdentifier: "NewsControlCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as? NewsHeaderCell else { preconditionFailure("NewsHeaderCell cannot be dequeued") }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell else { preconditionFailure("NewsTextCell cannot be dequeued") }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as? NewsImageCell else { preconditionFailure("NewsImageCell cannot be dequeued") }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsControlCell", for: indexPath) as? NewsControlCell else { preconditionFailure("NewsControlCell cannot be dequeued") }
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
}
