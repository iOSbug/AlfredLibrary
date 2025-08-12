# AlfredLibrary

[![CI Status](https://img.shields.io/travis/519955268@qq.com/AlfredLibrary.svg?style=flat)](https://travis-ci.org/519955268@qq.com/AlfredLibrary)
[![Version](https://img.shields.io/cocoapods/v/AlfredLibrary.svg?style=flat)](https://cocoapods.org/pods/AlfredLibrary)
[![License](https://img.shields.io/cocoapods/l/AlfredLibrary.svg?style=flat)](https://cocoapods.org/pods/AlfredLibrary)
[![Platform](https://img.shields.io/cocoapods/p/AlfredLibrary.svg?style=flat)](https://cocoapods.org/pods/AlfredLibrary)

## Example App

You can follow the Example App to learn how to use it. But we need to make the Example App works fisrt:
```
$ cd Examples

$ pod install

```
Then, open the Example.xcworkspace/ by Xcode and start it!

## Requirements

## Installation

AlfredLibrary is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

pod 'AlfredLibrary','16.2.07'


podFile:

platform :ios, '11.0'
use_frameworks!

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
  end
end

abstract_target 'commonPods' do

  pod 'AlfredLibrary','16.2.07'

  target 'AlfredLibraryDemo' do
      pod 'SnapKit'
  end
  
end


```


## Author

519955268@qq.com, 519955268@qq.com

## License

AlfredLibrary is available under the MIT license. See the LICENSE file for more info.
