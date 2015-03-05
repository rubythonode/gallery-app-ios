plugin 'cocoapods-keys', {
  :project => 'Gallery',
  :keys => [
    'GallerySpaceId',
    'GalleryAccessToken'
  ]}

source 'https://github.com/CocoaPods/Specs'
source 'https://github.com/contentful/CocoaPodsSpecs'

platform :ios, '8.0'

inhibit_all_warnings!

target 'Gallery' do

#use_frameworks!

pod 'ContentfulDeliveryAPI', :head
pod 'ContentfulDialogs'
pod 'ContentfulPersistence'
pod 'ContentfulStyle', :head
pod 'KVOController'
pod 'SOZOChromoplast'
pod 'SPLUserActivity'
pod 'ZoomInteractiveTransition', :git => 'git@github.com:neonichu/ZoomInteractiveTransition.git',
	:branch => 'reset-alpha-after-animation'

end

target 'GalleryTests' do

pod 'FBSnapshotTestCase'

end

