Pod::Spec.new do |s|
  s.name         = 'TFImagePickerController'
  s.platform     = :ios, '7.0'
  s.version      = '0.1.0'
  s.summary      = 'Browse and pick your Facebook picture like you would do with UIImagePickerController'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = 'https://github.com/robinmonjo/TFImagePickerController'
  s.author       = { 'Robin Monjo' => 'robinmonjo@gmail.com' }
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/robinmonjo/TFImagePickerController.git', :tag => '0.1.0' }
  s.source_files = 'Library/*.swift'
  s.resources    = 'Library/TFImagePickerController.storyboard'
  s.dependency 'AFNetworking', '~> 2.4'
  s.dependency 'Facebook-iOS-SDK', '~> 3.17'
end
