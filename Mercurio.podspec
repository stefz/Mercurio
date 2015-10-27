#
# Be sure to run `pod lib lint Mercurio.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Mercurio"
  s.version          = "0.1.0"
  s.summary          = "Mercurio is a fast way to call an api and parse the response"
  s.homepage         = "https://github.com/stefz/Mercurio"
  s.license          = 'MIT'
  s.author           = { "Stefano Zanetti" => "sstefano.zanetti@pragmamark.org" }
  s.source           = { :git => "https://github.com/stefz/Mercurio.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/stezanna'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Mercurio' => ['Pod/Assets/*.png']
  }

  s.dependency 'AFNetworking', '~> 2.6.1'
  s.dependency 'Mantle', '~> 2.0.5'
  s.dependency 'SSKeychain', '~> 1.2.3'
end
