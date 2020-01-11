//
//  NewsCell.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class NewsCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var notificationToken: NotificationToken?
    
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var newsDataLabel: UILabel!
    
    @IBOutlet var newsTextLabel: UILabel!
    @IBOutlet var albumView: UICollectionView!
        
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var likeCountLabel: UILabel!
    
    public var ownerId = Int()
    public var albumId = Int()
    
    var photos = [RealmPhoto]()
    private lazy var realmPhotos: Results<RealmPhoto> = try! Realm(configuration: RealmService.deleteIfMigration).objects(RealmPhoto.self).filter("ownerId == %@ AND albumId == %@", ownerId, albumId)

    
    class var customCell : NewsCell {
        let cell = Bundle.main.loadNibNamed("NewsCell", owner: self, options: nil)?.last
        return cell as! NewsCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.newsTextLabel.sizeToFit()
                
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        self.albumView.collectionViewLayout = flowLayout
        
        let cellNib = UINib(nibName: "AlbumCell", bundle: nil)
        self.albumView.register(cellNib, forCellWithReuseIdentifier: "AlbumCell")
        
    }

    func updateCellWith(owner: Int, album: Int) {
        self.ownerId = owner
        self.albumId = album
        //print("NewsCell: updateCellWith: ownerId: \(ownerId)")
        //print("NewsCell: updateCellWith: albumId: \(albumId)")
        photos = Array(realmPhotos)
        //print("NewsCell: updateCellWith: photos.count: \(photos.count)")

        
        self.notificationToken = realmPhotos.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case let .update(results, deletions, insertions, modifications):
                self.photos = Array(self.realmPhotos)
                self.albumView.reloadData()
            case let .error(error):
                print(error)
            }
        })

        self.albumView.reloadData()
    }

    //MARK: Collection view datasource and Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("NewsCell: Collection view datasource: photos.count: \(photos.count)")
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumCell
        
        cell?.cellImageView.kf.setImage(with: URL(string: photos[indexPath.item].image))
        //cell?.updateCellWithImage(name: albumPhoto)
        
        return cell!
    }

    deinit {
        notificationToken?.invalidate()
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
