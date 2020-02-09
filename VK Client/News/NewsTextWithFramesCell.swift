//
//  NewsTextWithFramesCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 09.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsTextWithFramesCell: UITableViewCell {
    var newsTextLabel = UILabel()
    public var newsTextHeight = CGFloat()
    public var sectionIndex = Int()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "NewsTextWithFramesCell")
        setupSubviews()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    private func setupSubviews() {
        super.layoutSubviews()
        contentView.addSubview(newsTextLabel)
        newsTextLabel.numberOfLines = 0
        newsTextLabel.lineBreakMode = .byWordWrapping
        newsTextLabel.font = newsTextLabel.font.withSize(14)

    }
    
    override func layoutSubviews() {
        //let newsTextLabelSize = newsTextLabel.intrinsicContentSize
        //print("NewsTextCell: newsTextLabel.intrinsicContentSize: \(newsTextLabelSize)")
        //let height = newsTextLabel.intrinsicContentSize.height
        //newsTextLabel.frame = CGRect(x: 10, y: 0, width: self.bounds.width - 10, height: height)
        
        let maxSize: CGSize = CGSize(width: self.bounds.width - 20, height: 9999)
        let fitSize: CGSize = newsTextLabel.sizeThatFits(maxSize)
        let origin = CGPoint(x: 10, y: 0)
        newsTextLabel.frame = CGRect(origin: origin, size: fitSize)
        newsTextHeight = fitSize.height

    }
    
}
