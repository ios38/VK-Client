//
//  PhotosLayout.swift
//  VK Client
//
//  Created by Maksim Romanov on 27.11.2019.
//  Copyright © 2019 Maksim Romanov. All rights reserved.
//

import UIKit

class PhotosLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]() //Атрибуты для заданных индексов
    var columnsCount = 2
    var cellHeight: CGFloat = 128
    private var totalCellsHeight: CGFloat = 0 //Cуммарная высота всех ячеек
    
    override func prepare() {
        super.prepare()
        
        cellHeight = (collectionView?.bounds.width)! / 2
        
        cacheAttributes = [:] //Инициализируем атрибуты
        guard let collectionView = self.collectionView else { return } //Проверяем наличие collectionView
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else { return } //Проверяем, что в секции есть хотя бы одна ячейка
        
        let bigCellWidth = collectionView.bounds.width //Определяем ширину ячеек
        let smallCellWidth = collectionView.bounds.width / CGFloat(columnsCount)
        
        //Рассчитываем f​rame для каждой ячейки
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributtes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (((index + 1) % (columnsCount + 1)) == 0)
            
            if isBigCell {
                attributtes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: cellHeight)
                //print("big \(attributtes.frame)")
                lastY += cellHeight
            } else {
                attributtes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: cellHeight)
                //print("small \(attributtes.frame)")

                let isLastColumn = (index + 2) % (columnsCount + 1) == 0 || index == (itemsCount - 1)
                
                if isLastColumn {
                    lastX = 0
                    lastY += cellHeight
                } else {
                    lastX += smallCellWidth
                }
                //print(index)
                //print("lastX \(lastX)")
                //print("lastY \(lastY)")

            }
            
            //Добавляем аттрибуты в словарь
            cacheAttributes[indexPath] = attributtes
        }
        //Cуммарная высота всех ячеек
        totalCellsHeight = lastY
    }
    
    //Аттрибуты для заданных области и индекса
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    //Переопределяем ​collecitonViewContentSize
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0,
                      height: totalCellsHeight)
    }


}
