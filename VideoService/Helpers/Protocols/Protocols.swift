//
//  Protocols.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import UIKit


protocol CollectionImgUpdaterDelegate : class {
    /**
     Update the cell of the collection when the image uploader change the status
     -parameters indexPath: collection IndexPath
     -parameters info: current loaded image
     
     */
    func colletionUpdate(indexPath:IndexPath, image: DefaultImage)
}

/** Reaction to user action */
protocol UserActionDelegate : class {
    func action(width:UIViewController)
}
