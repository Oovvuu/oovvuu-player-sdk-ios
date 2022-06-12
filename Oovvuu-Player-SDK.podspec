Pod::Spec.new do |s|

    s.name         = "Oovvuu-Player"
    s.version      = "0.8.0"
    s.summary      = "Oovvuu Player SDK for iOS"
    s.homepage     = "https://support.oovvuu.com/"
    s.license      = { :type => 'Commercial', :file => 'LICENSE.md' }
    s.author       = { "Oovvuu" => "support@oovvuu.com" }

    s.platform = :ios

    s.ios.deployment_target  = '14.0'

    s.source       = { :git => "https://github.com/Oovvuu/oovvuu-player-sdk-ios.git", :tag => "v#{s.version}" }
    s.requires_arc = true

    s.dependency 'Brightcove-Player-IMA', '6.10.4'
    
    s.ios.vendored_framework   = "OovvuuPlayerSDK.xcframework"

end
