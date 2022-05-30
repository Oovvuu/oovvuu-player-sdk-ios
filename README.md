# oovvuu-player-sdk-ios
Oovvuu Player SDK for iOS

# Manual Installation

To add the Oovvuu Player SDK to your project manually:

1. Download the Oovvuu Player SDK framework.
2. Download the Brightcove Player SDK framework.
3. Download the IMA Plugin for Brightcove Player SDK framework.
4. Download the Google IMA framework.
5. On the "General" tab of your application target, add the dynamic framework, OovvuuPlayerSDK.framework, from the Oovvuu Player SDK download to the list of Frameworks, Libraries, Embedded Content. The dynamic framework, OovvuuPlayerSDK.framework, is found in the xcframework directory of the download.
6. On the "General" tab of your application target, add the dynamic framework, BrightcovePlayerSDK.framework, from the Brightcove Player SDK download to the list of Frameworks, Libraries, Embedded Content. The dynamic framework, BrightcovePlayerSDK.framework, is found in the ios/dynamic directory of the download.
7. On the "General" tab of your application target, add BrightcoveIMA.framework from the IMA Plugin for Brightcove Player SDK download to the list of Frameworks, Libraries, Embedded Content.
8. On the "General" tab of your application target, add GoogleInteractiveMediaAds.framework from the Google IMA download to the list of Frameworks, Libraries, Embedded Content.
9. On the "Build Settings" tab of your application target, ensure that the "Framework Search Paths" include the paths to the frameworks. This should have been done automatically unless the framework is stored under a different root directory than your project.
10. On the "Build Settings" tab of your application target:
11. Ensure that -ObjC has been added to the "Other Linker Flags" build setting.
