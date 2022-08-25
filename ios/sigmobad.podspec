#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sigmobad.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sigmobad'
  s.version          = '0.0.1'
  s.summary          = 'sigmob广告flutter版'
  s.description      = <<-DESC
sigmob广告flutter版
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.dependency 'SigmobAd-iOS', '4.2.1'
  s.dependency 'SDWebImage', '5.12.1'
  s.dependency 'Masonry'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
