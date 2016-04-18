#
# Be sure to run `pod lib lint FerrisMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FerrisMenu"
  s.version          = "0.1.0"
  s.summary          = "A circular menu."


  s.description      = <<-DESC
     A circular menu where the text or icons stay upright upon rotation like a Ferris wheel.
                       DESC

  s.homepage         = "https://github.com/genedelisa/FerrisMenu"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Gene De Lisa" => "gene@rockhoppertech.com" }
  s.source           = { :git => "https://github.com/genedelisa/FerrisMenu.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/GeneDeLisaDev'

  s.ios.deployment_target = '9.3'

  s.source_files = 'FerrisMenu/Classes/**/*'
  s.resource_bundles = {
    'FerrisMenu' => ['FerrisMenu/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
