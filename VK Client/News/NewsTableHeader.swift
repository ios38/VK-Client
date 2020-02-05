//
//  NewsTableHeader.swift
//  VK Client
//
//  Created by Maksim Romanov on 02.02.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class NewsTableHeader: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var sources = [NewsSource]()/*{
        didSet {
            collectionView.reloadData()
        }
    }*/

    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumLineSpacing = 3.0
        flowLayout.minimumInteritemSpacing = 3.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
    }*/

    override init(frame: CGRect) {
        super.init(frame: frame)
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
//        print("NewsTableHeader: collectionView: sources.count: \(sources.count)")
//        cell.backgroundColor = .lightGray
        cell.cellImageView.kf.setImage(with: URL(string: sources[indexPath.item].image))
        return cell
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //collectionView.frame = bounds
        collectionView.frame = CGRect(x: 5, y: 5, width: self.bounds.width - 10, height: self.bounds.height - 10)
    }
}
