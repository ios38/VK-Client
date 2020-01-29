//
//  NewsControlCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 19.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsControlCell: UITableViewCell {
    @IBOutlet var newsLikeImageView: UIImageView!
    @IBOutlet var newsLikeCountLabel: UILabel!
    @IBOutlet var newsCommentsCountLabel: UILabel!
    @IBOutlet var newsRepostsCountLabel: UILabel!
    @IBOutlet var newsViewsCount: UILabel!
    
    public func configure(with item: RealmNews) {
        newsLikeCountLabel.text = String(item.likeCount)
        let imageName = item.isLiked == 1 ? "heart.fill" : "heart"
        newsLikeImageView.image = UIImage(systemName: imageName)
        newsCommentsCountLabel.text = String(item.commentsCount)
        newsRepostsCountLabel.text = String(item.repostsCount)
        newsViewsCount.text = String(item.viewsCount)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
