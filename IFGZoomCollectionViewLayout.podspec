#
# Be sure to run `pod lib lint IFGZoomCollectionViewLayout.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "IFGZoomCollectionViewLayout"
  s.version          = "0.1.0"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Emmanuel Merali" => "emmanuel@merali.me" }
  s.summary          = "A Mac OS dock like layout for UICollectionView."
  s.homepage         = "https://github.com/ifullgaz/IFGZoomCollectionViewLayout"

  s.platform         = :ios, '7.0'
  s.source           = { :git => "https://github.com/ifullgaz/IFGZoomCollectionViewLayout.git", :tag => s.version.to_s }
  s.source_files     = 'IFGZoomCollectionViewLayout/*'

  s.requires_arc     = true
end
