//
//  NewsTextCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 19.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsTextCell: UITableViewCell {
    @IBOutlet var newsTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsTextLabel.numberOfLines = 0
        newsTextLabel.lineBreakMode = .byWordWrapping
        newsTextLabel.font = newsTextLabel.font.withSize(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
