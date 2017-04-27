//
//  BaseViewController.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import AVKit
import AVFoundation
import UIKit



class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CollectionImgUpdaterDelegate, UIScrollViewDelegate  {
    
    //working table view
    var tableView: UITableView!
    
    //data sources
    var videos: Array<Video> = []
    
    //refreshing
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    var loadingStatus: Bool = false
    public var spinner: Spinner = Spinner(title: InformationMessages.loading)
    
    //API image queue manager
    var queueManager  = ImgLoaderQueueManager()
    
    //API requests settings
    var videosRequests = VideosRequests(category: .videos, offset: 0, limit: Constants.videoslimit)
    var videosSections: VideosSections = .sectionFeatured
    var videosOffset: Int = Constants.videosOffset
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        
        self.setRefreshControl(for: #selector(self.refreshSelector))
        
        self.spinner.setup()
        self.newVideosRequests()
        self.view.addSubview( self.spinner)
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        refreshSelector()
    }
    
    
    // MARK: - PUBLIC
    
    //MARK:  Work with  api server
    
    /** Request from api server */
    func newVideosRequests() {
        
        self.spinner.show()
        videosRequests.videos(from: videosSections).send.simpleRequest{  [unowned self]  videoModel in
            
            
            guard let videoModel = videoModel else { self.spinner.hide();  return }
            
            self.videos += videoModel.videos
            self.addImgLoadQueue(videoModel.videos)
            
            self.loadingStatus = false
            
            self.spinner.hide()
        }
    }
    
    /** This method adds all images of cells that you want to display */
    public func addImgLoadQueue( _ videos: Array<Video> ){
        
        self.queueManager.imageList += videos.map{ (video) -> DefaultImage in DefaultImage(url: video.thumbnail_url) }
        
        tableViewAddNewRow(videos)
         
    }
    
    /** To not reload the entire table, add only what you need */
    func tableViewAddNewRow(_ videos: Array<Video> ){
        
        let statrIndex  = self.tableView.numberOfRows(inSection: 0)
        
        let addIndexPath = videos.enumerated().map{ (number, element) -> IndexPath in
            IndexPath(item: statrIndex+number, section: 0)
        }
        
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: addIndexPath, with: .none)
        self.tableView.endUpdates()
    }
    
    
    // MARK: Collection Img Updater Delegate
    
    /** This delegate method updates the cell, after the image has been uploaded */
    internal func colletionUpdate(indexPath:IndexPath, image: DefaultImage) {
        if let _ = tableView.cellForRow(at: indexPath) {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    
    // MARK: video player
    
    /** Show video player and start video */
    public func showThis(video: Video){
        let moviePlayer = AVPlayerViewController()
        moviePlayer.player = AVPlayer(url: video.complete_url!)
        moviePlayer.player?.play()
        moviePlayer.showsPlaybackControls = true
        
        present(moviePlayer, animated: true, completion: nil)
    }
    
    
    
    // MARK: On-demand data Refresh
    
    
    /** Add Refresh Control to the tableView */
    public func setRefreshControl(for selector: Selector, title:String = ""){
        self.refreshControl.attributedTitle = NSAttributedString(string: title)
        self.refreshControl.addTarget(self, action: selector, for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    /** Update tableView at the request of the user : Pull to refresh */
    public func refreshSelector() {
        
        defer{refreshControl.endRefreshing()}
        refreshControl.beginRefreshing()
        
        self.videosRequests.offset = 0
        self.videos.removeAll()
        self.queueManager.cleanQueue()
        
        self.tableView.reloadData()
        self.newVideosRequests()
    }
    
    
    
    // MARK: - PRIVATE
    
    
    
}


//Cell class
class TableViewControllerCell: UITableViewCell {
     
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var likes_count: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
}
