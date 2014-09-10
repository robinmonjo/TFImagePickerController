//
//  TFPhotoCollectionViewController.swift
//  TFImagePickerController
//
//  Created by Robin Monjo on 07/09/14.
//  Copyright (c) 2014 Robin Monjo. All rights reserved.
//


class TFImageCollectionViewController: UICollectionViewController {

  var photosMetadata: [[String:AnyObject]] = []
  var albumTitle: String = ""
  private lazy var imageDownloader: TFImageDownloader = {
    return TFImageDownloader()
    }()
  
  var delegate: TFImagePickerControllerDelegate?
  var imagePickerController: TFImagePickerController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = self.albumTitle
  }
  
  private let IMAGE_VIEW_TAG = 100
  private let SPINNER_TAG = 200
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.photosMetadata.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as UICollectionViewCell
    cell.backgroundColor = UIColor.lightGrayColor()
    let imageView = cell.viewWithTag(IMAGE_VIEW_TAG) as UIImageView
    let spinner = cell.viewWithTag(SPINNER_TAG) as UIActivityIndicatorView
    spinner.hidesWhenStopped = true
    
    let photoMetadata = self.photosMetadata[indexPath.row]
    let photoUrl = photoMetadata["picture"]! as String
    
    spinner.startAnimating()
    self.imageDownloader.downloadImageAtUrl(photoUrl, completion: {(image, error) -> Void in
      spinner.stopAnimating()
      if error != nil {
        printError(error!)
        return
      }
      imageView.image = image
    })
    
    return cell
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) -> Void {
    if self.delegate? != nil {
      let photoMetadata = self.photosMetadata[indexPath.row] as [String: AnyObject]
      let fullSizedPhotoUrl = photoMetadata["source"]! as String
      let cell = collectionView.cellForItemAtIndexPath(indexPath)
      let spinner = cell!.viewWithTag(SPINNER_TAG) as UIActivityIndicatorView
      spinner.startAnimating()
      self.imageDownloader.downloadImageAtUrl(fullSizedPhotoUrl, completion: {(image, error) -> Void in
        spinner.stopAnimating()
        if error != nil {
          printError(error!)
        } else {
          self.delegate!.imagePickerController(self.imagePickerController!, didPickImage: image!, withMetadata: photoMetadata)
        }
      })
    }
  }
  
}
