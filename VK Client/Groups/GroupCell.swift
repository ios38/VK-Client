//
//  GroupCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 25.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!
    
    public func configure(with group: RealmGroup) {
        cellLabel.text = group.name
        cellImage.kf.setImage(with: URL(string: group.image))
    }

}
