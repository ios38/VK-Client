//
//  GroupCellXib.swift
//  VK Client
//
//  Created by Maksim Romanov on 07.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class GroupCellXib: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!
    
    public func configure(with group: RealmGroup) {
        cellLabel.text = group.name
        cellImage.kf.setImage(with: URL(string: group.image))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
                
        //self.backgroundColor = .clear
        //cellImage.layer.cornerRadius = cellImage.bounds.width/2
        
    }

}
