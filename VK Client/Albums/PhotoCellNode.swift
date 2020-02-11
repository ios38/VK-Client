//
//  PhotoCellNode.swift
//  VK Client
//
//  Created by Maksim Romanov on 12.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoCellNode: ASCellNode {
    private let imageNode = ASNetworkImageNode()

    private let photo: String

    init(photo: String) {
        self.photo = photo
        
        super.init()
        
        backgroundColor = .darkGray
        
        setupSubnodes()
    }

    private func setupSubnodes() {
        addSubnode(imageNode)
        imageNode.url = URL(string: (photo))
        imageNode.clipsToBounds = true
        imageNode.contentMode = .scaleAspectFill
        imageNode.shouldRenderProgressImages = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        //let width = constrainedSize.max.width
        imageNode.style.preferredSize = CGSize(width: 200, height: 200)
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }

}
