#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint roam_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'roam_flutter'
  s.version          = '0.1.5'
  s.summary          = 'This plugin allows to use the Roam.ai SDK in your Flutter mobile application on iOS and Android.'
  s.description      = 'This plugin allows to use the Roam.ai SDK in your Flutter mobile application on iOS and Android.'
  s.homepage         = 'https://roam.ai'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Roam B.V' => 'support@roam.ai' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'roam-ios', '~> 0.1.14'
  s.static_framework = true
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
