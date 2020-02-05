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
        cellImage.backgroundColor = .gray
        contentView.addSubview(likeView)
        likeView.backgroundColor = .white
        likeView.layer.cornerRadius = likeView.bounds.height/2
        likeView.layer.opacity = 0.5
        likeView.addSubview(likeImage)
        likeView.addSubview(likeCountLabel)
        likeCountLabel.font = likeCountLabel.font.withSize(20)
        likeCountLabel.textColor = .black

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellImage.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        likeView.frame = CGRect(x: 5, y: self.bounds.height - 35, width: 90, height: 30)
        likeView.layer.cornerRadius = likeView.bounds.height/2
        likeImage.frame = CGRect(x: 3, y: 3, width: likeView.bounds.height - 6, height: likeView.bounds.height - 6)
        layoutLikeCountLabel()

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
    /*
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = contentView.bounds.width
        let textblock = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        
        let rect = text.boundingRect(with: textblock,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [.font : font],
                                     context: nil)
        
        let width = rect.width.rounded(.up)
        let height = rect.height.rounded(.up)
        return CGSize(width: width, height: height)
    }*/
        private func layoutLikeCountLabel() {
    //        let likeCountLabelSize = getLabelSize(text: dateLabel.text ?? "", font: dateLabel.font)
            let likeCountLabelSize = likeCountLabel.intrinsicContentSize
            
            let origin = CGPoint(x: likeView.bounds.midX - likeCountLabelSize.width/2, y: 3)
            likeCountLabel.frame = CGRect(origin: origin, size: likeCountLabelSize)
        }

}
