//
//  BaseViewControllerExtension.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation


import Foundation
import AVKit
import AVFoundation
import UIKit

extension BaseViewController  {
    
    
    
    // MARK: - UI TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! TableViewControllerCell
        
        cell.title.text = videos[indexPath.row].title
        cell.likes_count.text = videos[indexPath.row].likes_count.description + " likes"

        let image = queueManager.imageList[indexPath.row]
        
        if image.view == nil { image.view = cell.thumbnail }
        
       
        switch (image.state){
            case .New:  ImgLoaderManager.send(image: image, indexPath: indexPath, queueManager: queueManager, delegat: self )
            case .Loading, .Downloaded : break
            case .Failed: ImgLoaderManager.send(image: image, indexPath: indexPath, queueManager: queueManager, delegat: self )
        }
        
        cell.thumbnail.image =  image.image
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let realHeight = (queueManager.imageList[indexPath.row].image.size.height / UIScreen.main.scale)

        return (realHeight > 360) ? 360 : realHeight
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showThis(video: videos[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == videos.count-2 && !loadingStatus {
            self.loadingStatus = true
            self.videosRequests.offset! += self.videosOffset
            self.newVideosRequests()
        }
    }
    
    
}
