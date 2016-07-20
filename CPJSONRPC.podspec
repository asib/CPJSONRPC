#
# Be sure to run `pod lib lint CPJSONRPC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CPJSONRPC'
  s.version          = '0.1.0'
  s.summary          = 'A framework for working with JSON-RPC APIs.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CPJSONRPC provides an interface that eases interaction with APIs that conform
to the JSON-RPC protocol. It offers classes for holding notification/request/response
data and producing a JSON-RPC object, as well as a helper class for parsing
a string into an object of the relevant class (CPJSONRPCNotification, CPJSONRPCRequest,
or CPJSONRPCResponse).
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/CPJSONRPC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jacob Fenton' => 'jacob.d.fenton@gmail.com' }
  s.source           = { :git => 'https://github.com/asib/CPJSONRPC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CPJSONRPC/Classes/**/*'

  # s.resource_bundles = {
  #   'CPJSONRPC' => ['CPJSONRPC/Assets/*.png']
  # }

  s.public_header_files = 'Pod/Classes/Public/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
