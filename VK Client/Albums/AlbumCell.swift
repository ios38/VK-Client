//
//  AlbumCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    @IBOutlet var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.darkGray
    }
    /*
    func updateCellWithImage(name:String) {
        self.cellImageView.image = UIImage(named: name)
    }*/


}
