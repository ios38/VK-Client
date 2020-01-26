//
//  NewsHeaderCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 18.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsHeaderCell: UITableViewCell {
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsSourceLabel: UILabel!
    @IBOutlet var newsDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
