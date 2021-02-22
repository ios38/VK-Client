//
//  FriendCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 26.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import Kingfisher

class FriendCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!    
    @IBOutlet var cellLabel: UILabel!
    
    //public func configure(with friend: RealmUser) {
    //public func configure(with friend: User) {
    public func configure(with friend: UserViewModel) {
        //cellLabel.text = friend.lastName + " " + friend.firstName
        cellLabel.text = friend.name
        //cellImage.kf.setImage(with: URL(string: friend.photo))
        cellImage.image = friend.photo
    }
}

