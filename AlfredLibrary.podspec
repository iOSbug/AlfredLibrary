#
# Be sure to run `pod lib lint AlfredLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlfredLibrary'
  s.version          = '0.3.2'
  s.summary          = 'A short description of AlfredLibrary.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/iOSbug/AlfredLibrary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '519955268@qq.com' => '519955268@qq.com' }
  s.source           = { :git => 'https://github.com/iOSbug/AlfredLibrary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.vendored_frameworks = "libs/*.{framework}"
#  s.vendored_frameworks = "**/AlfredLibrary.framework"
#  s.vendored_frameworks = "**/AlfredCore.framework"
#  s.vendored_frameworks = "**/AlfredNetManager.framework"

  s.frameworks   = 'NetworkExtension','Foundation','CoreLocation'

  s.dependency 'HandyJSON', '~> 5.0.3-beta'
  s.dependency 'Alamofire'
  s.dependency 'CocoaAsyncSocket'
  s.dependency 'FCUUID'
  s.dependency 'CocoaSecurity'
  s.dependency 'SwiftSH'
  s.dependency 'NMSSH'

  # s.resource_bundles = {
  #   'AlfredLibrary' => ['AlfredLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
