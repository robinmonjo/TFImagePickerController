//
//  TFImagePickerController.swift
//  TFImagePickerController
//
//  Created by Robin Monjo on 07/09/14.
//  Copyright (c) 2014 Robin Monjo. All rights reserved.
//

import UIKit

class TFImagePickerController: UITableViewController {
  
  class func imagePickerController() -> TFImagePickerController {
    let storyboard = UIStoryboard(name: "TFImagePickerController", bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier("TFImagePickerController") as TFImagePickerController
  }
  
  private var albumsMetadata: [[String:AnyObject]] = []
  private var selectedAlbumPhotosMetadata: [[String:AnyObject]] = []
  private var selectedAlbumTitle = ""
  
  var delegate: TFImagePickerControllerDelegate?
  
  private lazy var imageDownloader: TFImageDownloader = {
    return TFImageDownloader()
    }()
  
  private let IMAGE_VIEW_TAG = 100
  private let TEXT_LABEL_TAG = 200
  private let DETAILS_LABEL_TAG = 300
  private let SPINNER_TAG = 400
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if !FBSession.activeSession().isOpen {
      FBSession.openActiveSessionWithReadPermissions(["user_photos"], allowLoginUI: true, completionHandler: { (session, state, error) -> Void in
        if error != nil {
          printError(error)
          return
        }
        self.downloadAlbumdMetadata()
      })
    } else {
      self.downloadAlbumdMetadata()
    }
  }
  
  private func downloadAlbumdMetadata() {
    FBRequestConnection.startWithGraphPath("me/albums", completionHandler: { (connection, result, error) -> Void in
      if error != nil {
        printError(error)
        return
      }
      self.albumsMetadata = result.valueForKey("data") as [[String:AnyObject]]
      self.tableView.reloadData()
    })
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.albumsMetadata.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as UITableViewCell
    
    let imageView = cell.viewWithTag(IMAGE_VIEW_TAG) as UIImageView
    let textLabel = cell.viewWithTag(TEXT_LABEL_TAG) as UILabel
    let detailsLabel = cell.viewWithTag(DETAILS_LABEL_TAG) as UILabel
    let spinner = cell.viewWithTag(SPINNER_TAG) as UIActivityIndicatorView
    
    var albumMetadata = self.albumsMetadata[indexPath.row]
    let albumName = albumMetadata["name"]! as String
    if let albumPhotoCount: AnyObject = albumMetadata["count"] {
      detailsLabel.text = "\(albumPhotoCount as Int)"
    } else {
      detailsLabel.text = ""
    }
    textLabel.text = albumName
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    
    //Get back url to album's cover photo
    if let albumCoverPhoto: AnyObject = albumMetadata["cover_photo"] {
      spinner.startAnimating()
      var path = "/\(albumCoverPhoto as String)"
      FBRequestConnection.startWithGraphPath(path, completionHandler: { (connection, result, error) -> Void in
        if error != nil {
          printError(error)
          return
        }
        if let imageUrl: AnyObject? = result["picture"] {
          self.imageDownloader.downloadImageAtUrl(imageUrl as String, completion: {(image, error) -> Void in
            spinner.stopAnimating()
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
    let albumName = self.albumsMetadata[indexPath.row]["name"]! as String
    self.selectedAlbumTitle = albumName
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
        printError(error)
        return
      }
      self.selectedAlbumPhotosMetadata = result.valueForKey("data") as [[String:AnyObject]]
      self.performSegueWithIdentifier("ALBUMS_TO_PHOTOS", sender: self)
    })
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "ALBUMS_TO_PHOTOS" {
      let vc = segue.destinationViewController as TFImageCollectionViewController
      vc.photosMetadata = self.selectedAlbumPhotosMetadata
      vc.albumTitle = self.selectedAlbumTitle
      vc.delegate = self.delegate
      vc.imagePickerController = self
    }
  }
  
  @IBAction func cancelTapped(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: {() in
      if self.delegate != nil {
        self.delegate!.imagePickerControllerDidCancel(self)
      }
    })
  }
  
}
