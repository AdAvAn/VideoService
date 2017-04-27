//
//  MultipleImageLoader.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import UIKit
import Alamofire

enum ImageLoadingState {
    case New, Loading, Downloaded, Failed
}


// MARK: Retailers
//
// The basic protocol for the Retailer list
//
protocol ToBeImage {
    var url:URL {get set}
    var state: ImageLoadingState  {get set}
    var view:UIImageView? {get set}
    var image: UIImage  {get set}
    var indicator: ActivityIndicator? {get set}
}




class DefaultImage: ToBeImage, Equatable  {
    
    //url
    var url:URL
    
    //Status before downloading
    var state: ImageLoadingState = .New
    
    //Image data, default Placeholder
    var image: UIImage = UIImage()
    
    //Which will be added images after loading and an activity indicator
    weak var view: UIImageView?
    
    //Activity indicator
    var indicator: ActivityIndicator?  = nil
    var delayBeforeIndicatorStart: TimeInterval!
    var durationOfIndicatorShow: TimeInterval!
    
    private var startIndicatorTimer:Timer? = nil
    private var stopIndicatorTimer:Timer? = nil
    
    init(url:URL, indicatorDelay:TimeInterval? = nil, indicatorDuration:TimeInterval? = nil) {
        self.delayBeforeIndicatorStart = indicatorDelay ?? Constants.startActivityIndicatorDelay
        self.durationOfIndicatorShow = indicatorDuration ?? TimeInterval (Constants.imgLoadingRegestTimeOut)
        self.url=url
    }
    
    
    convenience  init(url:URL,  view: UIImageView) {
        self.init(url: url)
        self.view = view
    }
    
    convenience  init(url:URL, view: UIImageView, indicatorDelay:TimeInterval? = nil, indicatorDuration:TimeInterval? = nil) {
        self.init(url:url,  indicatorDelay:indicatorDelay, indicatorDuration:indicatorDuration)
        self.view = view
    }
    
    
    // MARK: PUBLIC
    
    
    /** Hides the activity indicator, stops the timer */
    public func stopRequestTimer(){
        indicatorStop()
    }
    
    
    
    /** Activates the activity indicator and the timer is limited to the execution time of the request */
    public func startRequestTimer(){
        indicatotStart()
        //self.startIndicatorTimer =  scheduleTimer(timeInterval: self.delayBeforeIndicatorStart, selector: #selector(indicatotStart))
    }
    
    
    // MARK: PRIVATE
    
    /** Strt the activity indicator */
    @objc private func indicatotStart(){
        //self.startIndicatorTimer?.invalidate()
        // self.startIndicatorTimer = nil
        
        if let _ = self.view {
            self.indicator = ActivityIndicator(view:  view!)
            self.indicator!.start()
            self.stopIndicatorTimer =  scheduleTimer(timeInterval: durationOfIndicatorShow, selector: #selector(stopRequestTimerWithTimeOut))
        }
    }
    
    
    /** Stop the activity indicator*/
    private func indicatorStop(){
        self.startIndicatorTimer?.invalidate()
        self.startIndicatorTimer = nil
        
        guard
            let _ = self.view,
            let _ =  self.indicator else  { return }
        
        self.stopIndicatorTimer?.invalidate()
        self.indicator!.stop()
        self.indicator = nil
    }
    
    /** Starts the timer */
    private func scheduleTimer(timeInterval: TimeInterval, selector: Selector, data: Any? = nil) -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: data, repeats: false)
    }
    
    
    
    /**
     If the query execution time has expired, and the query result has not yet been received.
     Show the error to the user, stop querying.
     */
    @objc private func stopRequestTimerWithTimeOut(){
        stopRequestTimer()
        self.image  = UIImage(named: "placeholder")!
    }
    
    static func == (lhs:DefaultImage, rhs:DefaultImage) -> Bool { // Implement Equatable
        return lhs.url == rhs.url
    }
    
}




/** This class manages the download queue */
class ImgLoaderQueueManager {
    
    private var isSuspended:Bool = false
    lazy var activeTasksIndexPatch = Dictionary<IndexPath,Operation>()
    var imageList: Array<DefaultImage> = []
    var downloadQueue = OperationQueue()
    
    
    init(isSuspended:Bool = false){
        self.isSuspended = isSuspended
        
        self.downloadQueue.name = "com.video.img.loader.queue"
        self.downloadQueue.qualityOfService = .userInteractive
        self.downloadQueue.isSuspended = isSuspended
    }
    
    /** Stop loading and clear the queue */
    public func cleanQueue(){
        self.downloadQueue.cancelAllOperations()
        self.activeTasksIndexPatch.removeAll()
        self.imageList.removeAll()
    }
}




class ImgLoaderOperation: Operation {
    
    var image: DefaultImage
    let loader  = ImageLoader.instance
    weak var delegate: CollectionImgUpdaterDelegate?
    let indexPath: IndexPath
    
    
    init(img image: DefaultImage, indexPath: IndexPath, delegate: CollectionImgUpdaterDelegate?) {
        self.image = image
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    
    override func main() {
        if self.isCancelled {
            self.downloaded(this: nil)
            callTheDelegate()
            return
        }
        
        self.load()
    }
    
    
    
    /** This method loads an image in a background thread and returns to the main */
    public func load() {
        
        
        
        DispatchQueue.main.sync { [unowned self] in self.image.startRequestTimer() }
        
        
        loader.getImage(from: image.url)  { [unowned self]
            image in
            
            DispatchQueue.main.sync { [unowned self] in
                
                guard let image = image else {
                    self.downloaded(this: nil)
                    return
                }
                
                self.downloaded(this: image)
            }
        }
        
        
    }
    
    
    /**
     Processing of results  downloaded.
     -parameter img: Downloaded result
     */
    private func downloaded(this img:UIImage?){
        
        self.image.stopRequestTimer()
        
        //false loaded
        guard let img = img else {
            self.image.state = .Failed
            self.image.image = UIImage(named: "placeholder")!
            callTheDelegate()
            return
        }
        
        //true loaded
        self.image.image = img
        self.image.state = .Downloaded
        
        
        callTheDelegate()
    }
    
    
    /**
     Reply to delegate
     */
    private func callTheDelegate(){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.colletionUpdate(indexPath: self.indexPath, image: self.image)
    }
    
}
