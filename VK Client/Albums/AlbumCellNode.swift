//
//  AlbumCellNode.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
//import RealmSwift
import AsyncDisplayKit

class AlbumCellNode: ASCellNode, ASCollectionDelegate, ASCollectionDataSource {
    //private var notificationToken: NotificationToken?
    private let parsingService = ParsingService()
    private let networkService = NetworkService()
    private var collectionNode: ASCollectionNode
    
    private let owner: Int
    private let album: String

    private var photos = [Photo]()
    //private lazy var realmPhotos: Results<RealmPhoto> = try! Realm(configuration: RealmService.deleteIfMigration).objects(RealmPhoto.self).filter("ownerId == %@ AND albumId == %@", owner, album)
    
    init(owner: Int, album: String) {
        self.owner = owner
        self.album = album
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //flowLayout.itemSize = CGSize(width: 200, height: 200)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        
        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        super.init()
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.backgroundColor = .black
        //backgroundColor = .darkGray
        //self.photos = realmPhotos.map{ $0.image }

        setupSubnodes()
    }
    
    override func didLoad() {
        loadAlbum()
    }
    
    private func loadAlbum() {
        NetworkService
            .loadAlbumData(owner: owner, album: album)
            .map(on: DispatchQueue.global()) { data in
                try self.parsingService.parsingPhotos(data)
            }.done { photos in
                self.photos = photos
                self.collectionNode.reloadData()
                //try? RealmService.save(items: photos)
            }.catch { error in
                print(error)
                //self.show(error: error)
            }
    }

    private func setupSubnodes() {
        addSubnode(collectionNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        let height = constrainedSize.max.height
        collectionNode.style.preferredSize = CGSize(width: width, height: height)
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
            return PhotoCellNode(photo: photo.image, aspectRatio: photo.aspectRatio)
        }
        
        return cellNodeBlock
    }

}
