//
//  AlbumsASController.swift
//  VK Client
//
//  Created by Maksim Romanov on 10.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift
import AsyncDisplayKit

class AlbumsASController: ASViewController<ASDisplayNode>, ASTableDelegate, ASTableDataSource {
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    let realmService: RealmService
    private lazy var realmPhotos: Results<RealmPhoto> = try! RealmService.get(RealmPhoto.self).filter("ownerId == 156700636")
    var photos = [RealmPhoto]()

    init(realmService: RealmService) {
        self.realmService = realmService
        super.init(node: ASTableNode())
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
        self.photos = Array(self.realmPhotos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.row {
        case 0:
            let cellNodeBlock = { () -> ASCellNode in
                let node = AlbumCellNode(row: indexPath.row)
                return node
            }
            return cellNodeBlock
        default:
            return { ASCellNode() }
        }
    }
}
