//
//  FBImagePickerDelegateProtocol.swift
//  FBImagePicker
//
//  Created by Robin Monjo on 07/09/14.
//  Copyright (c) 2014 Robin Monjo. All rights reserved.
//


protocol TFImagePickerControllerDelegate {
  func imagePickerController(controller: TFImagePickerController!, didPickImage image: UIImage, withMetadata metadata:[String:AnyObject])
  func imagePickerControllerDidCancel(controller: TFImagePickerController!)
}