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
    private let row: Int
    private lazy var realmPhotos: Results<RealmPhoto> = try! RealmService.get(RealmPhoto.self).filter("ownerId == 156700636")
    private var photo = RealmPhoto()
    private let imageNode = ASNetworkImageNode()
    
    init(row: Int) {
        self.row = row
        
        super.init()
        self.photo = Array(realmPhotos)[row]
        setupSubnodes()
    }
    
    private func setupSubnodes() {
        addSubnode(imageNode)
        imageNode.url = URL(string: photo.image)
        imageNode.clipsToBounds = true
        imageNode.contentMode = .scaleAspectFill
        imageNode.shouldRenderProgressImages = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        imageNode.style.preferredSize = CGSize(width: width, height: width * CGFloat(photo.aspectRatio))
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
