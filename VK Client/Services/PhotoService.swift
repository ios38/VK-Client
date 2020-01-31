//
//  PhotoService.swift
//  VK Client
//
//  Created by Maksim Romanov on 30.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class PhotoService {
    private var cacheLifeTime: TimeInterval = 60*60*24*7
    private static var memoryCache = [String: UIImage]() //запретить многопоточную запись
    private var isolatedQueue = DispatchQueue(label: "ru.romanov.vk-client.memoryCache")
    
    private var imageCacheUrl: URL? = {
        let dirName = "Images"
        
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let url = cacheDir.appendingPathComponent(dirName, isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        //print ("PhotoService: imageCacheUrl: url: \(url)")
        //print ("PhotoService: imageCacheUrl: url.path: \(url.path)")
        return url
    }()
    
    private func getFilePath(urlString: String) -> URL? {
        let fileName = urlString.split(separator: "/").last ?? "default.png"
        guard let imageCacheUrl = self.imageCacheUrl else { return nil }
        return imageCacheUrl.appendingPathComponent(String(fileName))
    }
    
    private func saveImageToFilesystem(urlString: String, image: UIImage) {
        guard let data = image.pngData(),
            let fileUrl = getFilePath(urlString: urlString) else { return }
        
        //FileManager.default.createFile(atPath: fileUrl.absoluteString, contents: data, attributes: nil)
        try! data.write(to: fileUrl)
        //print("PhotoService: saveImageToFilesystem: \(fileUrl.absoluteString)")
    }
    
    private func loadImagesFromFilesystem(urlString: String) -> UIImage? {
        guard let fileUrl = getFilePath(urlString: urlString),
            let info = try? FileManager.default.attributesOfItem(atPath: fileUrl.absoluteString),
            let modificationDate = info[.modificationDate] as? Date else { return nil }
        
        let imageLifeTime = Date().distance(to: modificationDate)
        
        guard imageLifeTime < cacheLifeTime,
            let image = UIImage(contentsOfFile: fileUrl.absoluteString) else { return nil }
        isolatedQueue.async {
            PhotoService.memoryCache[urlString] = image
        }
        return image
    }
    
    private func loadImage(urlString: String) -> Promise<UIImage> {
        Alamofire.request(urlString)
            .responseData()
            .map { (data, _) -> UIImage in
                guard let image = UIImage(data: data) else { throw PMKError.badInput }
                return image }
            .get(on: isolatedQueue) { PhotoService.memoryCache[urlString] = $0 }
            .get { self.saveImageToFilesystem(urlString: urlString, image: $0) }
    }
    
    public func photo(urlString: String) -> Promise<UIImage> {
        if let image = PhotoService.memoryCache[urlString] {
            print ("PhotoService: load from memoryCache: \(urlString)")
            return Promise.value(image)
        } else
            if let image = loadImagesFromFilesystem(urlString: urlString) {
            print ("PhotoService: load from Filesystem: \(urlString)")
            return Promise.value(image)
        }
        print ("PhotoService: load from Alamofire: \(urlString)")
        return loadImage(urlString: urlString)
    }
}
