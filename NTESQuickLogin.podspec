#
# Be sure to run `pod lib lint NTESQuickLogin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NTESQuickLogin'
  s.version          = '0.1.0'
  s.summary          = 'NTESQuickLogin.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      =  'Add long description of the pod here'

  s.homepage         = 'https://github.com/yidun/NTESQuickPass'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luolihao123456' => 'luolihao123456@163.com' }
  s.source           = { :git => 'https://github.com/yidun/NTESQuickPass.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.vendored_frameworks = ['NTESQuickLogin/Classes/TYRZSDK.framework','NTESQuickLogin/Classes/OAuth.framework','NTESQuickLogin/Classes/EAccountApiSDK.framework','NTESQuickLogin/Classes/NTESQuickPass.framework']
      
  s.resource_bundles = {
       'NTESQuickLogin' => ['NTESQuickLogin/Assets/sdk_oauth.bundle','NTESQuickLogin/Assets/TYRZResource.bundle']
   }
       
  s.libraries = 'c++.1'
  
  # s.resource_bundles = {
  #   'NTESQuickLogin' => ['NTESQuickLogin/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
