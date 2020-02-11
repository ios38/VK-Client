//
//  AlbumCellNode.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AlbumCellNode: ASCellNode {
    private let photo: RealmPhoto
    private let imageNode = ASNetworkImageNode()
    
    init(photo: RealmPhoto) {
        self.photo = photo
        super.init()
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
