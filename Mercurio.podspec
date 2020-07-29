#
# Be sure to run `pod lib lint Mercurio.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Mercurio"
  s.version          = "0.3.0"
  s.summary          = "Mercurio is a fast way to make an api with AFNetworking and parse the response with Mantle."
  s.homepage         = "https://github.com/stefz/Mercurio"
  s.license          = 'MIT'
  s.author           = { "Stefano Zanetti" => "stefano.zanetti@pragmamark.org" }
  s.source           = { :git => "https://github.com/stefz/Mercurio.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/stezanna'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.public_header_files = 'Pod/Classes/**/*'
  s.header_mappings_dir = 'Pod/Classes'

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'Mantle', '~> 2.0.6'
  s.dependency 'SAMKeychain', '~> 1.5.1'
end
