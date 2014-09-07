//
//  RMImageDownloader.swift
//  FBImagePicker
//
//  Created by Robin Monjo on 07/09/14.
//  Copyright (c) 2014 Robin Monjo. All rights reserved.
//

class RMImageDownloader {
  
  lazy var operationQueue: NSOperationQueue = {
    return NSOperationQueue()
  }()

  func downloadImageAtUrl(url: String, completion: ( image: UIImage?, error: NSError? ) -> Void ) -> Void {
    let request = NSURLRequest(URL: NSURL(string: url))
    let requestOperation = AFHTTPRequestOperation(request: request)
    requestOperation.responseSerializer = AFImageResponseSerializer()
    requestOperation.setCompletionBlockWithSuccess({(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
      completion(image: responseObject as? UIImage, error: nil)
    }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
      completion(image: nil, error: error)
    })
    self.operationQueue.addOperation(requestOperation)
  }
  
}
