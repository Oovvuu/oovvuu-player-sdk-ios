# Oovvuu Player SDK for iOS, version 0.8 (alpha)

## Installation

Oovvuu Player SDK provides a dynamic library framework for installation.

SDK supports version 3.14.4 of the Google IMA SDK for iOS

### CocoaPods

You can use [CocoaPods][cocoapods] to add the Oovvuu Player SDK to your project.  You can find the latest `Oovvuu-Player` podspec [here][podspecs]. The pod will incorporate the correct version of SDK automatically.

CocoaPod Podfile example:

```bash
source 'https://github.com/Oovvuu/oovvuu-player-sdk-ios.git'

use_frameworks!
platform :ios, '14.0'

target 'MyTestOovvuuPlayer' do
  pod 'Oovvuu-Player'
end
```

### Manual

To add the IMA Plugin for Brightcove Player SDK to your project manually:

1. Download the [Oovvuu Player SDK][oovvuusdkrelease] framework.
1. Download the [Brightcove Player SDK][bcovsdkrelease] framework.
1. Download the [IMA Plugin for Brightcove Player SDK][bcoveimarelease] framework.
1. Download the [Google IMA][googleima] framework.
1. On the "General" tab of your application target, add the **dynamic** framework, OovvuuPlayerSDK.framework, from the Oovvuu Player SDK download to the list of **Frameworks, Libraries, Embedded Content**. The dynamic framework, OovvuuPlayerSDK.framework, is found in the ios/dynamic directory of the download.
1. On the "General" tab of your application target, add BrightcovePlayerSDK.framework from the IMA Plugin for Brightcove Player SDK download to the list of **Frameworks, Libraries, Embedded Content**.
1. On the "General" tab of your application target, add BrightcoveIMA.framework from the IMA Plugin for Brightcove Player SDK download to the list of **Frameworks, Libraries, Embedded Content**.
1. On the "General" tab of your application target, add GoogleInteractiveMediaAds.framework from the Google IMA download to the list of **Frameworks, Libraries, Embedded Content**.
1. On the "Build Settings" tab of your application target, ensure that the "Framework Search Paths" include the paths to the frameworks. This should have been done automatically unless the framework is stored under a different root directory than your project.
1. On the "Build Settings" tab of your application target:
    * Ensure that `-ObjC` has been added to the "Other Linker Flags" build setting.

[oovvuusdkrelease]: https://github.com/brightcove/brightcove-player-sdk-ios/releases
[bcovsdkrelease]: https://github.com/brightcove/brightcove-player-sdk-ios/releases
[bcoveimarelease]: https://github.com/brightcove/brightcove-player-sdk-ios-ima/releases
[googleima]: https://developers.google.com/interactive-media-ads/docs/sdks/ios/download
[cocoapods]: http://cocoapods.org
[podspecs]: https://github.com/Oovvuu/oovvuu-player-sdk-ios/tree/main
