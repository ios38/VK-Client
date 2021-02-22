//
//  NewsTableHeaderCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 02.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsTableHeaderCell: UICollectionViewCell {
    
    @IBOutlet var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //print("NewsTableHeaderCell: awakeFromNib")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("NewsTableHeaderCell: init")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }

}
