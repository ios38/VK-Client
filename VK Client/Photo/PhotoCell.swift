//
//  PhotoCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 26.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoCellDelegate: class {
    func likePhoto()
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeView: UIView!
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var likeCount: UILabel!
    
    @IBOutlet var isLikedLabel: UILabel!
    
    public weak var delegate: PhotoCellDelegate?
    
    
    var isLiked: Int = 0 {
        didSet {
            if self.isLiked == 1 {
                self.likeImage.image = UIImage(systemName: "heart.fill")
                } else {
                self.likeImage.image = UIImage(systemName: "heart")
            }
        }
    }
    
    //Не работает счетчик
    public func configure(with photo: RealmPhoto) {
        cellImage.kf.setImage(with: URL(string: photo.image))
        likeCount.text = String(photo.likeCount)
        isLikedLabel.text = String(photo.isLiked)

        if isLiked == 1 {
            print("configure: isLiked = 1")
            self.likeImage.image = UIImage(systemName: "heart.fill")
            } else {
            print("configure: isLiked = 0")
            self.likeImage.image = UIImage(systemName: "heart")
        }

    }

    
    override func awakeFromNib() {
        likeView.layer.cornerRadius = likeView.bounds.height/2
        
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tapLike.numberOfTapsRequired = 1
        likeView.addGestureRecognizer(tapLike)
        
    }
    
    @objc func likeTapped(_ tapGesture: UITapGestureRecognizer) {
        //isLiked.toggle()
        delegate?.likePhoto()
        
        
        
        UIView.transition(with: likeImage, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            if self.isLiked == 1 {
                                self.likeImage.image = UIImage(systemName: "heart")
                                self.isLiked = 0
                                } else {
                                self.likeImage.image = UIImage(systemName: "heart.fill")
                                self.isLiked = 1
                                }
                            }, completion: nil)
    }

}

