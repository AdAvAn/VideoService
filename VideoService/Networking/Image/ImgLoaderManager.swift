//
//  ImgLoaderManager.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation



final class ImgLoaderManager {
    
    /**
     Send a request for downloading images to  a collection.
     */
    public static func send(image: DefaultImage, indexPath: IndexPath, queueManager:ImgLoaderQueueManager,  delegat: CollectionImgUpdaterDelegate){
        
        if let _ = queueManager.activeTasksIndexPatch[indexPath] {
            delegat.colletionUpdate(indexPath: indexPath, image: image)
            return
        }
        
        let downloader = ImgLoaderOperation(img: image, indexPath:indexPath, delegate:delegat)
        
        queueManager.activeTasksIndexPatch[indexPath] = downloader
        queueManager.downloadQueue.addOperation(downloader)
        
        image.state = .Loading
    }
    
}
