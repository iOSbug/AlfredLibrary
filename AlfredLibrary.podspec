#
# Be sure to run `pod lib lint AlfredLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlfredLibrary'
  s.version          = '16.3.05'
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
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '519955268@qq.com' => '519955268@qq.com' }
  s.source           = { :git => 'https://github.com/iOSbug/AlfredLibrary.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.default_subspec     = 'Core'
  
  s.subspec 'Core' do |ss|

    ss.vendored_frameworks = "libs/*.{framework}"

    ss.resources           = 'AlfredBundle.bundle'
    ss.preserve_paths      = 'libs/*', 'AlfredBundle.bundle'

    ss.frameworks   = 'NetworkExtension','Foundation','CoreLocation'


    ss.dependency 'Alamofire', '5.10.2'
    ss.dependency 'CocoaAsyncSocket'
    ss.dependency 'FCUUID'
    ss.dependency 'CocoaSecurity'

   end
   
end
