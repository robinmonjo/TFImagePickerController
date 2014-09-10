### TFImagePickerController


UIImagePickerController for Facebook pictures in Swift. It's available as a Cocoapod but **it's not working**
since it's a `swift` pod relying on `Objective-C` pod (`Facebook-iOS-SDK` and `AFNetworking`).

![Alt text](https://dl.dropboxusercontent.com/u/6543817/record-TFImagePickerController.gif)

## Usage

````swift

// [...]

let imagePickerController = TFImagePickerController.imagePickerController()
imagePickerController.delegate = self  // seelf should implement the TFImagePickerControllerDelegate protocol
let navigationController = UINavigationController(rootViewController: imagePickerController)
self.presentViewController(navigationController, animated: false, completion: {})

// [...]

func imagePickerController(controller: TFImagePickerController!, didPickImage image: UIImage, withMetadata metadata: [String:AnyObject]) {
	// do stuff, metadata contains facebook API hash
  controller.dismissViewControllerAnimated(true, completion: {})
}

func imagePickerControllerDidCancel(controller: TFImagePickerController!) {
	//do stuff
}

````
