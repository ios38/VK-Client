//
//  NewsTableHeader.swift
//  VK Client
//
//  Created by Maksim Romanov on 02.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsTableHeader: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var sources = [NewsSource]()
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        print("NewsTableHeader: awakeFromNib: sources.count: \(sources.count)")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "NewsTableHeader"
        addSubview(label)
        

        let cellNib = UINib(nibName: "NewsTableHeaderCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "NewsTableHeaderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsTableHeaderCell", for: indexPath) as! NewsTableHeaderCell
        print("NewsTableHeader: collectionView: sources.count: \(sources.count)")
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func newsSourceImage(_ source: Int) -> (String) {
        var image = ""
        if source > 0 {
            let realmNewsSource = Array(try! RealmService.get(RealmUser.self).filter("id == %@", source))
            image = realmNewsSource.first?.photo ?? ""
        } else {
            let realmNewsSource = Array(try! RealmService.get(RealmGroup.self).filter("id == %@", -source))
            image = realmNewsSource.first?.image ?? ""
        }
        return (image)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
}
