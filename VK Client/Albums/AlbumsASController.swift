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
    private var notificationToken: NotificationToken?
    private let parsingService = ParsingService()

    public var ownerId = -39968672 //Int()
    //var albumId = Int()
    
    var albums = [Int]()
    //var owner = [RealmUser]()

    //let realmService: RealmService
    
    private lazy var realmAlbums: Results<RealmAlbums> = try! RealmService.get(RealmAlbums.self).filter("ownerId == %@", ownerId)
    //private lazy var realmOwner: Results<RealmUser> = try! RealmService.get(RealmUser.self).filter("id == %@", -ownerId)

    init(/*realmService: RealmService*/) {
        //self.realmService = realmService
        super.init(node: ASTableNode())
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
        albums = realmAlbums.map{ $0.id }
        //owner = Array(self.realmOwner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        NetworkService
            .loadAlbums(owner: ownerId)
            .map(on: DispatchQueue.global()) { data in
                try self.parsingService.parsingAlbums(data)
            }.done { albums in
                try? RealmService.save(items: albums)
            }.catch { error in
                self.show(message: error.localizedDescription)
            }

        self.notificationToken = realmAlbums.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update(_, _, _, _):
                //self.albums = Array(self.realmAlbums)
                self.albums = self.realmAlbums.map{ $0.id }
                self.tableNode.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }

    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return albums.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.row {
        case 0:
            let cellNodeBlock = { () -> ASCellNode in
                let node = AlbumCellNode(owner: self.ownerId, album: self.albums[indexPath.section])
                return node
            }
            return cellNodeBlock
        default:
            return { ASCellNode() }
        }
    }
}
