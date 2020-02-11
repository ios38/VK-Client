//
//  AlbumCellNode.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift
import AsyncDisplayKit

class AlbumCellNode: ASCellNode, ASCollectionDelegate, ASCollectionDataSource {
    private var notificationToken: NotificationToken?
    private let parsingService = ParsingService()
    private var collectionNode: ASCollectionNode
    
    private let owner: Int
    private let album: Int

    private var photos = [String]()
    private lazy var realmPhotos: Results<RealmPhoto> = try! Realm(configuration: RealmService.deleteIfMigration).objects(RealmPhoto.self).filter("ownerId == %@ AND albumId == %@", owner, album)
    
    init(owner: Int, album: Int) {
        self.owner = owner
        self.album = album
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        
        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        super.init()

        self.photos = realmPhotos.map{ $0.image }

        setupSubnodes()
    }
    
    override func didLoad() {
        print("AlbumCellNode: didLoad: album: \(album)")
        NetworkService
            .loadAlbum(owner: owner, album: album)
            .map(on: DispatchQueue.global()) { data in
                try self.parsingService.parsingPhotos(data)
        }.done { photos in
            try? RealmService.save(items: photos)
            print("AlbumCellNode: didLoad: photos: \(photos.count)")
        }.catch { error in
            print(error)
            //self.show(error: error)
        }
        /*
        self.notificationToken = realmPhotos.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                self.photos = self.realmPhotos.map{ $0.image}
                self.aspects = self.realmPhotos.map{ $0.aspectRatio }
                //self.albumView.reloadData()
            case let .error(error):
                print(error)
            }
        })*/
    }
    
    private func setupSubnodes() {
        addSubnode(collectionNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        collectionNode.style.preferredSize = CGSize(width: width, height: 200)
        return ASWrapperLayoutSpec(layoutElement: collectionNode)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return photos.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let photo = photos[indexPath.section]
        let cellNodeBlock = { () -> ASCellNode in
            return PhotoCellNode(photo: photo)
        }
        
        return cellNodeBlock
    }

}
