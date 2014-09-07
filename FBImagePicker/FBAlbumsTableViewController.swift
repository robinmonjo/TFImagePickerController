//
//  FBAlbumsTableViewController.swift
//  FBImagePicker
//
//  Created by Robin Monjo on 07/09/14.
//  Copyright (c) 2014 Robin Monjo. All rights reserved.
//

import UIKit

class FBAlbumsTableViewController: UITableViewController {
  
  var albumsMetadata: [[String:AnyObject]] = []
  var selectedAlbumPhotosMetadata: [[String:AnyObject]] = []
  var selectedAlbumId: String = ""
  var placeHolderImage: UIImage = UIImage()
  lazy var imageDownloader: RMImageDownloader = {
    return RMImageDownloader()
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(44, 44), false, 0.0);
    self.placeHolderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    FBSession.openActiveSessionWithReadPermissions(["user_photos"], allowLoginUI: true, completionHandler: { (session, state, error) -> Void in
      if error != nil {
        println("Failed to open FBSession \(error)")
        return
      }
      self.downloadAlbumdMetadata()
    })
  }
  
  func downloadAlbumdMetadata() {
    FBRequestConnection.startWithGraphPath("me/albums", completionHandler: { (connection, result, error) -> Void in
      println(error)
      println(result)
      self.albumsMetadata = result.valueForKey("data") as [[String:AnyObject]]
      self.tableView.reloadData()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.albumsMetadata.count
  }
  

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as UITableViewCell
    
    let imageView = cell.viewWithTag(100) as UIImageView
    let textLabel = cell.viewWithTag(200) as UILabel
    let detailsLabel = cell.viewWithTag(300) as UILabel
    let activityIndicator = cell.viewWithTag(400) as UIActivityIndicatorView
    activityIndicator.hidesWhenStopped = true
    
    var albumMetadata = self.albumsMetadata[indexPath.row]
    let albumName = albumMetadata["name"]! as String
    if let albumPhotoCount = albumMetadata["count"] {
      detailsLabel.text = "\(albumPhotoCount as Int)"
    } else {
      detailsLabel.text = ""
    }
    textLabel.text = albumName
    imageView.image = self.placeHolderImage
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    
    //Get back url to album's cover photo
    if let albumCoverPhoto = albumMetadata["cover_photo"] {
      activityIndicator.startAnimating()
      var path = "/\(albumCoverPhoto as String)"
      FBRequestConnection.startWithGraphPath(path, completionHandler: { (connection, result, error) -> Void in
        if error != nil {
          println(error)
          return;
        }
        if let imageUrl = result["picture"] {
          self.imageDownloader.downloadImageAtUrl(imageUrl as String, completion: {(image, error) -> Void in
            activityIndicator.stopAnimating()
            if error != nil {
              println(error)
              return
            }
            imageView.image = image
          })
        }
        
      })
    }

    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 44
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    tableView.userInteractionEnabled = false
    let albumId = self.albumsMetadata[indexPath.row]["id"]! as String
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    spinner.frame = CGRectMake(0, 0, 24, 24)
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    let oldView = cell!.accessoryView
    cell!.accessoryView = spinner;
    spinner.startAnimating()
    spinner.hidesWhenStopped = true
    
    FBRequestConnection.startWithGraphPath("/\(albumId)/photos", completionHandler: { (connection, result, error) -> Void in
      spinner.stopAnimating()
      tableView.userInteractionEnabled = true
      cell!.accessoryView = oldView
      if error != nil {
        println(error)
        return
      }
      println(result)
      self.selectedAlbumPhotosMetadata = result.valueForKey("data") as [[String:AnyObject]]
      self.performSegueWithIdentifier("ALBUMS_TO_PHOTOS", sender: self)
    })
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "ALBUMS_TO_PHOTOS" {
      let vc = segue.destinationViewController as RMPhotoCollectionViewController
      vc.photosMetadata = self.selectedAlbumPhotosMetadata
    }
  }
  
}
