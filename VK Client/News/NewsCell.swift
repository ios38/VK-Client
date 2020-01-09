//
//  NewsCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var newsDataLabel: UILabel!
    
    @IBOutlet var newsTextLabel: UILabel!
    @IBOutlet var CollectionView: UICollectionView!
        
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.newsTextLabel.sizeToFit()
    }
    /*
    @IBAction func like(_ sender: Any) {
        isLiked.toggle()
        
        UIView.transition(with: likeButton, duration: 1,
                          options: .transitionCrossDissolve,
                          animations: {
                            if self.isLiked {
                                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
                                } else {
                                self.likeButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
                                }
                            }, completion: nil)

    }*/

}
