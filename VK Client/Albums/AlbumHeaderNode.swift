//
//  AlbumHeaderNode.swift
//  VK Client
//
//  Created by Maksim Romanov on 13.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AlbumHeaderNode: ASCellNode {
    private let dateNode = ASTextNode()
    private let textNode = ASTextNode()
    private let album: Album
    private let inset: CGFloat = 10
    
    init(album: Album) {
        self.album = album
        super.init()
        backgroundColor = .black
        setupSubnodes()
    }

    private var dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        //dt.dateFormat = "dd MMMM yyyy" //nsdateformatter.com
        dt.dateFormat = "dd.MM.yyyy." //nsdateformatter.com
        return dt
    }()

    private func setupSubnodes() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
        ]
        addSubnode(dateNode)
        print("AlbumHeaderNode: album.date: \(album.date)")
        let date = dateFormatter.string(from: album.date)
        dateNode.attributedText = NSAttributedString(string: date, attributes: attributes)
        dateNode.tintColor = .white
        dateNode.backgroundColor = .clear

        addSubnode(textNode)
        textNode.attributedText = NSAttributedString(string: album.text, attributes: attributes)
        textNode.tintColor = .white
        textNode.backgroundColor = .clear
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        //avatarImageNode.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: 0)
        let dateSpec = ASInsetLayoutSpec(insets: insets, child: dateNode)
        let nameSpec = ASInsetLayoutSpec(insets: insets, child: textNode)

        //let textCenterSpec = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: textNode)
        
        let horizontalStackSpec = ASStackLayoutSpec()
        horizontalStackSpec.direction = .horizontal
        horizontalStackSpec.children = [dateSpec, nameSpec]

        return horizontalStackSpec
    }

}
