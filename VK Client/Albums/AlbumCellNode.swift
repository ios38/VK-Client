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

class AlbumCellNode: ASCellNode {
    private var notificationToken: NotificationToken?
    private let parsingService = ParsingService()
    private let imageNode = ASNetworkImageNode()

    private let owner: Int
    private let album: Int

    var photos = [RealmPhoto]()
    private lazy var realmPhotos: Results<RealmPhoto> = try! Realm(configuration: RealmService.deleteIfMigration).objects(RealmPhoto.self).filter("ownerId == %@ AND albumId == %@", owner, album)
    
    init(owner: Int, album: Int) {
        self.owner = owner
        self.album = album

        super.init()
        self.photos = Array(realmPhotos)
        setupSubnodes()
    }
    
    private func setupSubnodes() {
        addSubnode(imageNode)
        imageNode.url = URL(string: photos.first?.image ?? "")
        imageNode.clipsToBounds = true
        imageNode.contentMode = .scaleAspectFill
        imageNode.shouldRenderProgressImages = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        let aspectRatio = CGFloat(photos.first?.aspectRatio ?? 0)
        imageNode.style.preferredSize = CGSize(width: width, height: width * aspectRatio)
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
