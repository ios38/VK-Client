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
    // Создаем дополнительный интерфейс для обращения к корневой ноде
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    private lazy var photos: Results<RealmPhoto> = try! RealmService.get(RealmPhoto.self).filter("ownerId == 156700636")
    var photo = RealmPhoto()
    
    init() {
        // Инициализируемся с таблицей в качестве корневого View / Node
        super.init(node: ASTableNode())
        // Привязываем к себе методы делегата и дата-сорса
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        // По желанию кастомизируем корневую таблицу
        self.tableNode.allowsSelection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        photo = photos.first!

    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 10
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.row {
        case 0:
            let cellNodeBlock = { () -> ASCellNode in
                let node = AlbumCellNode(photo: self.photo)
                return node
            }
            
            return cellNodeBlock
        default:
            return { ASCellNode() }
        }
    }
}
