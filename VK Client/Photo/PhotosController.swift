//
//  PhotosController.swift
//  VK Client
//
//  Created by Maksim Romanov on 26.10.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class PhotosController: UICollectionViewController {
    private var notificationToken: NotificationToken?
    //private let networkSrvice = NetworkService()
    public var ownerId = Int()
    var photos = [RealmPhoto]()
    //private lazy var realmPhotos: Results<RealmPhoto> = try! Realm(configuration: RealmService.deleteIfMigration).objects(RealmPhoto.self).filter("ownerId == %@", ownerId)
    private lazy var realmPhotos: Results<RealmPhoto> = try! RealmService.get(RealmPhoto.self).filter("ownerId == %@", ownerId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = sort(Array(realmPhotos))
        
        NetworkService.loadPhotos(token: Session.shared.accessToken, owner: ownerId, album: nil) { result in
            switch result {
            case let .success(photos):
                try? RealmService.save(items: photos)
            case let .failure(error):
                print(error)
            }
        }
        
        self.notificationToken = realmPhotos.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case let .update(results, deletions, insertions, modifications):
                self.photos = self.sort(Array(self.realmPhotos))
                self.collectionView.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }
    
    private func sort(_ photos: [RealmPhoto]) -> [RealmPhoto]{
        var unsortedPhotos = photos
        var sortedPhotos = [RealmPhoto]()
        
        //Формируем массив фото по принципу: 2 вертикальных, 1 горизонтальное и т.д.
        while unsortedPhotos.count > 0 {
            //Добавляем первое вертикальное фото (если такого нет, то горизонтальное)
            sortedPhotos.append(unsortedPhotos.first(where: { $0.type == "portrait"}) ?? unsortedPhotos.first(where: { $0.type == "landscape"})!)
            //Удаляем добавленное фото из массива, если count = 0 - break
            unsortedPhotos.removeAll { $0.id == sortedPhotos.last!.id }
            
            //Добавляем второе вертикальное фото (если такого нет, то горизонтальное)
            guard unsortedPhotos.count > 0 else { break }
            sortedPhotos.append(unsortedPhotos.first(where: { $0.type == "portrait"}) ?? unsortedPhotos.first(where: { $0.type == "landscape"})!)
            //Удаляем добавленное фото из массива, если count = 0 - break
            unsortedPhotos.removeAll { $0.id == sortedPhotos.last!.id }
            
            //Добавляем горизонтальное фото (если такого нет, то вертикальное)
            guard unsortedPhotos.count > 0 else { break }
            sortedPhotos.append(unsortedPhotos.first(where: { $0.type == "landscape"}) ?? unsortedPhotos.first(where: { $0.type == "portrait"})!)
            //Удаляем добавленное фото из массива, если count = 0 - break
            unsortedPhotos.removeAll { $0.id == sortedPhotos.last!.id }
            
        }
        return sortedPhotos
    }

    // MARK: - Table view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            preconditionFailure("PhotoCell cannot be dequeued")
        }
        
        cell.cellImage.kf.setImage(with: URL(string: photos[indexPath.row].image))
        cell.likeCount.text = String(photos[indexPath.row].likeCount)
        cell.isLiked = photos[indexPath.row].isLiked
        cell.isLikedLabel.text = String(photos[indexPath.row].isLiked)
        
        cell.delegate = self
               
        return cell
    }
    
    deinit {
        notificationToken?.invalidate()
    }

}

extension PhotosController: PhotoCellDelegate {
    func likePhoto() {
        print("Photo is liked")
    }
}

extension PhotosController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Big Photo",
            let selectedPhotoIndexPath = collectionView.indexPathsForSelectedItems?.first,
            let destination = segue.destination as? BigPhotoController {
            destination.bigPhotos = photos
            destination.selectedPhotoIndex = selectedPhotoIndexPath.item
            collectionView.deselectItem(at: selectedPhotoIndexPath, animated: true)
        }
    }
}
