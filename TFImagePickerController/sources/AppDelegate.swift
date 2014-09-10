//
//  AppDelegate.swift
//  FBImagePicker
//
//  Created by Robin Monjo on 07/09/14.
//  Copyright (c) 2014 Robin Monjo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TFImagePickerControllerDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    let imagePickerController = TFImagePickerController.imagePickerController()
    imagePickerController.delegate = self
    let navigationController = UINavigationController(rootViewController: imagePickerController)
    
    self.window!.rootViewController = UIViewController()
    
    self.window!.makeKeyAndVisible()
    
    self.window!.rootViewController!.presentViewController(navigationController, animated: false, completion: {})

    return true
  }
  
  func imagePickerController(controller: TFImagePickerController!, didPickImage image: UIImage, withMetadata metadata: [String:AnyObject]) {
    println(image)
    println(metadata)
    controller.dismissViewControllerAnimated(true, completion: {})
  }
  
  func imagePickerControllerDidCancel(controller: TFImagePickerController!) {
    println("Cancelled")
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
    return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
  }
  
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {

  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

