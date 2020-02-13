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
    private let aspectRatio: Float

    init(photo: String, aspectRatio: Float) {
        self.photo = photo
        self.aspectRatio = aspectRatio

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
        let height = constrainedSize.max.height
        let width = height / CGFloat(aspectRatio)
        imageNode.style.preferredSize = CGSize(width: width, height: height)
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }

}
