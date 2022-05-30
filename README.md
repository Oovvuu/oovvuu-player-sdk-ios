# oovvuu-player-sdk-ios
Oovvuu Player SDK for iOS

Manual Installation
To add the Oovvuu Player SDK to your project manually:

Download the Oovvuu Player SDK framework.
Download the Brightcove Player SDK framework.
Download the IMA Plugin for Brightcove Player SDK framework.
Download the Google IMA framework.
On the "General" tab of your application target, add the dynamic framework, OovvuuPlayerSDK.framework, from the Oovvuu Player SDK download to the list of Frameworks, Libraries, Embedded Content. The dynamic framework, OovvuuPlayerSDK.framework, is found in the xcframework directory of the download.
On the "General" tab of your application target, add the dynamic framework, BrightcovePlayerSDK.framework, from the Brightcove Player SDK download to the list of Frameworks, Libraries, Embedded Content. The dynamic framework, BrightcovePlayerSDK.framework, is found in the ios/dynamic directory of the download.
On the "General" tab of your application target, add BrightcoveIMA.framework from the IMA Plugin for Brightcove Player SDK download to the list of Frameworks, Libraries, Embedded Content.
On the "General" tab of your application target, add GoogleInteractiveMediaAds.framework from the Google IMA download to the list of Frameworks, Libraries, Embedded Content.
On the "Build Settings" tab of your application target, ensure that the "Framework Search Paths" include the paths to the frameworks. This should have been done automatically unless the framework is stored under a different root directory than your project.
On the "Build Settings" tab of your application target:
Ensure that -ObjC has been added to the "Other Linker Flags" build setting.
