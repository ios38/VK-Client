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

    public var ownerId: Int
    //var albumId = Int()
    
    //var albums = [String]()
    var albums = [Album]()
    //var owner = [RealmUser]()

    //let realmService: RealmService
    
    private lazy var realmAlbums: Results<RealmAlbum> = try! RealmService.get(RealmAlbum.self).filter("ownerId == %@", ownerId)
    //private lazy var realmOwner: Results<RealmUser> = try! RealmService.get(RealmUser.self).filter("id == %@", -ownerId)

    init(ownerId: Int) {
        self.ownerId = ownerId
        super.init(node: ASTableNode())
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
        tableNode.backgroundColor = .black

        albums = realmAlbums.filter{ $0.size > 1}.map{ Album(from: $0) }
        addWalltoAlbums()
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
                self.albums = self.realmAlbums.filter{ $0.size > 1}.map{ Album(from: $0) }
                self.addWalltoAlbums()
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
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let width = tableNode.bounds.width
        switch indexPath.row {
        case 0:
            let min = CGSize(width: width, height: 40)
            let max = CGSize(width: width, height: 40)
            return ASSizeRange(min: min, max: max)
        case 1:
            let min = CGSize(width: width, height: 200)
            let max = CGSize(width: width, height: 200)
            return ASSizeRange(min: min, max: max)            
        default:
            #warning ("Не нашел аналог UITableView.automaticDimension")
            let min = CGSize(width: width, height: 0)
            let max = CGSize(width: width, height: 0)
            return ASSizeRange(min: min, max: max)
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch indexPath.row {
        case 0:
            return { AlbumHeaderNode(album: self.albums[indexPath.section]) }
        case 1:
            let cellNodeBlock = { () -> ASCellNode in
                let album = self.albums[indexPath.section].id
                let node = AlbumCellNode(owner: self.ownerId, album: album)
                return node
            }
            return cellNodeBlock
        default:
            return { ASCellNode() }
        }
    }
    func addWalltoAlbums() {
        let wall = Album(
            id: "wall",
            ownerId: self.ownerId,
            date: Date(),
            text: "Фото со стены",
            size: 0
        )
        let profile = Album(
            id: "profile",
            ownerId: self.ownerId,
            date: Date(),
            text: "Фото из профиля",
            size: 0
        )
        self.albums.insert(wall, at: 0)
        self.albums.insert(profile, at: 0)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
