//
//  UIPhotoCollectionViewController.swift
//  FBImagePicker
//
//  Created by Robin Monjo on 07/09/14.
//  Copyright (c) 2014 Robin Monjo. All rights reserved.
//


class RMPhotoCollectionViewController: UICollectionViewController {

  var albumId: String = ""
  var photosMetadata: [[String:AnyObject]] = []
  lazy var imageDownloader: RMImageDownloader = {
    return RMImageDownloader()
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.photosMetadata.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as UICollectionViewCell
    cell.backgroundColor = UIColor.whiteColor()
    let imageView = cell.viewWithTag(100) as UIImageView
    let activityIndicator = cell.viewWithTag(200) as UIActivityIndicatorView
    activityIndicator.hidesWhenStopped = true
    
    let photoMetadata = self.photosMetadata[indexPath.row]
    let photoUrl = photoMetadata["picture"]! as String
    
    activityIndicator.startAnimating()
    self.imageDownloader.downloadImageAtUrl(photoUrl, completion: {(image, error) -> Void in
      activityIndicator.stopAnimating()
      if error != nil {
        println(error)
        return
      }
      imageView.image = image
    })
    
    return cell
  }
  
}
