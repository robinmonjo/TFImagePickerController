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
    FBRequestConnection.startWithGraphPath("/\(self.albumId)/photos", completionHandler: { (connection, result, error) -> Void in
      if error != nil {
        println(error)
        return
      }
      println(result)
      self.photosMetadata = result.valueForKey("data") as [[String:AnyObject]]
      self.collectionView!.reloadData()
    })
    
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
  
//
//  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection:(NSInteger)section {
//  return recipeImages.count;
//  }
//  
//  
//  - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//  static NSString *identifier = @"Cell";
//  
//  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//  
//  UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
//  recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
//  
//  return cell;
//  }
  
  
  
  
  
  
}
