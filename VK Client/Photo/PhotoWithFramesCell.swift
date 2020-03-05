//
//  PhotoWithFramesCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 05.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoWithFramesCellDelegate: class {
    func likePhoto(photoId: Int, isLiked: Int, likeCount: Int)
}

class PhotoWithFramesCell: UICollectionViewCell {
    let cellImage = UIImageView()
    let likeView = UIView()
    let likeImage = UIImageView()
    let likeCountLabel = UILabel()
    
    var photoId = -1
    var likeCount = 0
    public weak var delegate: PhotoWithFramesCellDelegate?
    
    
    var isLiked: Int = 0 {
        didSet {
            if self.isLiked == 1 {
                self.likeImage.image = UIImage(systemName: "heart.fill")
                } else {
                self.likeImage.image = UIImage(systemName: "heart")
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
        setupSubviews()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        contentView.addSubview(cellImage)
        cellImage.contentMode = .scaleAspectFill
        cellImage.backgroundColor = .gray
        contentView.addSubview(likeView)
        likeView.backgroundColor = .white
        likeView.layer.cornerRadius = likeView.bounds.height/2
        likeView.layer.opacity = 0.6
        likeView.addSubview(likeImage)
        likeImage.layer.opacity = 1
        likeImage.contentMode = .scaleAspectFill
        likeView.addSubview(likeCountLabel)
        likeCountLabel.layer.opacity = 1
        likeCountLabel.font = likeCountLabel.font.withSize(20)
        likeCountLabel.textColor = .black

        let tapLike = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tapLike.numberOfTapsRequired = 1
        likeView.addGestureRecognizer(tapLike)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let likeViewWidth = likeImage.bounds.width + 5 + likeCountLabel.bounds.width
        cellImage.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        likeImage.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        layoutLikeCountLabel()
        likeView.frame = CGRect(x: 5, y: self.bounds.height - 35, width:
            5 + likeImage.bounds.width + 5 + likeCountLabel.bounds.width + 10, height: 30)
        likeView.layer.cornerRadius = likeView.bounds.height/2

    }
    
    public func configure(with photo: RealmPhoto) {
        cellImage.kf.setImage(with: URL(string: photo.image))
        likeCount = photo.likeCount
        likeCountLabel.text = String(photo.likeCount)
        isLiked = photo.isLiked
        photoId = photo.id
        
        if self.isLiked == 1 {
            self.likeImage.image = UIImage(systemName: "heart.fill")
            } else {
            self.likeImage.image = UIImage(systemName: "heart")
        }

        setNeedsLayout()
    }

    private func layoutLikeCountLabel() {
            let likeCountLabelSize = likeCountLabel.intrinsicContentSize
            let origin = CGPoint(x: likeImage.bounds.width + 10, y: 3)
            likeCountLabel.frame = CGRect(origin: origin, size: likeCountLabelSize)
    }
    
    @objc func likeTapped(_ tapGesture: UITapGestureRecognizer) {
        UIView.transition(with: likeImage, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                                if self.isLiked == 1 {
                                    self.likeImage.image = UIImage(systemName: "heart")
                                    self.isLiked = 0
                                    self.likeCount -= 1
                                } else {
                                    self.likeImage.image = UIImage(systemName: "heart.fill")
                                    self.isLiked = 1
                                    self.likeCount += 1
                                }
                          }, completion: nil)
        
        delegate?.likePhoto(photoId: photoId, isLiked: isLiked, likeCount: likeCount)
    }

}
