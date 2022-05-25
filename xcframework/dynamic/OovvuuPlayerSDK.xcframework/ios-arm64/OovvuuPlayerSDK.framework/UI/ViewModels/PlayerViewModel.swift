//
//  PlayerViewModel.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 14/4/2022.
//

import UIKit
import BrightcovePlayerSDK
import BrightcoveIMA
import GoogleInteractiveMediaAds
import Combine

class PlayerViewModel {
    
    private let maxRetryCount = 5
    private var retryCount = 0
    private let retryInterval = 3.0
    
    @Published var state: PlayerState = .loading
    
    private let appId: String
    private let embedId: String
    private let apiKey: String
    private let hrefKey: String
    
    var isAdPlaying = false
    var isBrowserOpen = false
    
    var playbackService: BCOVPlaybackService?
    
    var brightcove: Brightcove?
    var video: Video?
    
    init(appId: String, embedId: String, apiKey: String, hrefKey: String) {
        self.appId = appId
        self.embedId = embedId
        self.apiKey = apiKey
        self.hrefKey = hrefKey
    }
    
    func requestData() {
        let client = APIClient()
        
        let request = OovvuuRequest(appId: appId, embedId: embedId, apiKey: apiKey)
        
        client.requestData(request: request) { [unowned self] result in
            switch result {
            case .success(let responce):
                handleSuccessState(responce: responce)
            case .failure(let error):
                handleErrorState(error: error)
            }
        }
    }
    
    private func handleErrorState(error: Error?) {
        state = .error(error)
        if retryCount < maxRetryCount {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + retryInterval, execute: {
                self.requestData()
                self.retryCount += 1
            })
        }
    }
    
    private func handleSuccessState(responce: OovvuuResponse) {
        guard let video = responce.videos.first else {
            handleErrorState(error: nil)
            return
        }
        self.brightcove = responce.brightcove
        self.video = video
        state = .success(responce)
        logLoadedAnnalitycsEvent(videoId: video.id, playerId: brightcove?.playerId)
    }
    
    func updateAdURL(adTag: String, videoProperties: [AnyHashable: Any], viewRect: CGRect) -> String {
        var updatedString = ""
        updatedString = adTag.replacingOccurrences(of: "{app.bundle}", with: Bundle.main.bundleIdentifier ?? "")
        updatedString = updatedString.replacingOccurrences(of: "{app.name}", with: String(describing: Bundle.appName()))
        updatedString = updatedString.replacingOccurrences(of: "{app.storeurl}", with: "http://itunes.com/apps/\(String(describing: Bundle.appName()))")
        updatedString = updatedString.replacingOccurrences(of: "{random}", with: String(describing: arc4random_stir()))

        updatedString = updatedString.replacingOccurrences(of: "{device.make}", with: "Apple")
        updatedString = updatedString.replacingOccurrences(of: "{device.model}", with: UIDevice.current.modelName)
        updatedString = updatedString.replacingOccurrences(of: "{device.id}", with: UIDevice.current.identifierForVendor?.uuidString ?? "")
        updatedString = updatedString.replacingOccurrences(of: "{player.height}", with: String(describing: viewRect.height))
        updatedString = updatedString.replacingOccurrences(of: "{player.width}", with: String(describing: viewRect.width))
        
        let location = Utils.getGeolocation()
        if location != nil {
            updatedString = updatedString.replacingOccurrences(of: "{geolocation.latitude}", with: String(describing: location?.coordinate.latitude))
            updatedString = updatedString.replacingOccurrences(of: "{geolocation.longitude}", with: String(describing: location?.coordinate.longitude))
        } else {
            updatedString = updatedString.replacingOccurrences(of: "{geolocation.latitude}", with: "")
            updatedString = updatedString.replacingOccurrences(of: "{geolocation.longitude}", with: "")
        }
        

        updatedString = updatedString.replacingOccurrences(of: "{mediainfo.id}", with: videoProperties["id"] as? String ?? "")
        updatedString = updatedString.replacingOccurrences(of: "{mediainfo.name}", with: videoProperties["name"] as? String ?? "")
        updatedString = updatedString.replacingOccurrences(of: "{mediainfo.tags}", with: (videoProperties["tags"] as? [String])?.joined(separator: ",") ?? "")
        updatedString = updatedString.replacingOccurrences(of: "{mediainfo.custom_fields.oovvuu_provider_id}", with: (videoProperties["custom_fields"] as? [String: String])?["oovvuu_provider_id"] as? String ?? "")
        updatedString = updatedString.replacingOccurrences(of: "{mediainfo.reference_id}", with: videoProperties["reference_id"] as! String)
        
        updatedString = updatedString.replacingOccurrences(of: "{player.muted}", with: "0")
        updatedString = updatedString.replacingOccurrences(of: "{player.id}", with: String(describing: brightcove?.playerId))//from brightcove object playerId
        
        updatedString = updatedString.replacingOccurrences(of: "{browser.ua}", with: Utils.getUserAgent())
        updatedString = updatedString.replacingOccurrences(of: "{window.location.href}", with: String(describing: hrefKey))
        
        //updatedString = "https://tv.springserve.com/vast/664904?ap=0&app_bundle=com.comp.ui.core&app_name=CompanyApp&app_store_url=https://play.google.com/store/apps/details?id=com.comp.ui.core&cb=7642801&consent=&content_genre=news&content_id=6267401943001&content_title=Quebec&coppa=0&device_make=iPhone&device_model=RMX2151&did=4dfb8415a5d8fc44&dnt=0&gdpr=0&h=200&iris_context=&iris_id=&lat=0&lon=0&max_dur=31000&min_dur=3000&mute=0&ovu_asset_type=shortform&ovu_keywords=news&ovu_provider_id=148&ovu_vtype=v2&payid=&placement=1&player_id=9eooXa43m&prodq=1&ref_id=322574&schain=1.0%2C1%21oovvuu.com%2C626853%2C1%2C%2C%2C&ua=Mozilla&url=mozilla&w=360"
        return updatedString
    }
}

extension PlayerViewModel {
    
    func getIMASettings(videoPublisherID: Int64?) -> IMASettings {
        let imaSettings = IMASettings()
        imaSettings.ppid = String(describing: videoPublisherID)
        imaSettings.language = NSLocale.current.languageCode
        
        return imaSettings
    }
    
    func getRenderSettings(presenter: UIViewController) -> IMAAdsRenderingSettings {
        let renderSettings = IMAAdsRenderingSettings()
        renderSettings.linkOpenerPresentingController = presenter
        renderSettings.linkOpenerDelegate = presenter as? IMALinkOpenerDelegate
        return renderSettings
    }
    
    func getAdsRequestPolicy() -> BCOVIMAAdsRequestPolicy {
        BCOVIMAAdsRequestPolicy.videoPropertiesVMAPAdTagUrl()
    }
    
    func getIMAPlaybackSessionOptions(sessionDelegate: UIViewController) -> [String : UIViewController] {
        [kBCOVIMAOptionIMAPlaybackSessionDelegateKey: sessionDelegate]
    }
    
    func getPlaybackControllerOptions() -> [String : Bool] {
        [kBCOVAVPlayerViewControllerCompatibilityKey : true]
    }
    
    func initPlaybackService(accountId: String?, policyKey: String?) {
        playbackService = BCOVPlaybackService(accountId: accountId, policyKey: policyKey)
    }
    
    func requestContentFromPlaybackService(videoID: String?, adTag: String?, viewRect: CGRect, authToken: String? = nil, onCompletion: @escaping ([Any]) -> ()) {
        playbackService?.findVideo(withVideoID: videoID, authToken: authToken, parameters: nil, completion: { [weak self] (video: BCOVVideo?, jsonResponse: [AnyHashable : Any]?, error: Error?) in
            
            if let video = video {
                
                let playlist = BCOVPlaylist(video: video)
                let updatedPlaylist = playlist?.update({ (mutablePlaylist: BCOVMutablePlaylist?) in
                    
                    guard let mutablePlaylist = mutablePlaylist else {
                        return
                    }
                    
                    var updatedVideos:[BCOVVideo] = []
                    
                    for video in mutablePlaylist.videos {
                        if let bcovVideo = video as? BCOVVideo,
                        let updatedVideo = self?.updateVideo(video: bcovVideo, adTag: adTag, viewRect: viewRect) {
                            updatedVideos.append(updatedVideo)
                        }
                    }
                    
                    mutablePlaylist.videos = updatedVideos
                    
                })
                
                if let updatedPlaylist = updatedPlaylist {
                    onCompletion(updatedPlaylist.videos)
                }
            }
            
            if let error = error {
                print("Error retrieving video: \(error.localizedDescription)")
            }
            
        })
    }
    
    func updateVideo(video: BCOVVideo, adTag: String?, viewRect: CGRect) -> BCOVVideo {
        if let adTag = adTag {
            return video.update { [unowned self] (mutableVideo: BCOVMutableVideo?) in
                guard let mutableVideo = mutableVideo else {
                    return
                }
                
                // The BCOVIMA plugin will look for the presence of kBCOVIMAAdTag in
                // the video's properties when using ad rules. This URL returns
                // a VMAP response that is handled by the Google IMA library.
                if var updatedProperties = mutableVideo.properties {
                    updatedProperties[kBCOVIMAAdTag] = updateAdURL(adTag: adTag, videoProperties: video.properties, viewRect: viewRect)
                    mutableVideo.properties = updatedProperties
                }
            }
        }
        return video
    }
}

extension PlayerViewModel {
    
    func logPlayAnnalitycsEvent(videoId: Int64?, playerId: String?) {
        logAnnalitycsEvent(videoId: videoId, playerId: playerId, event: .playVideo)
    }
    
    func logLoadedAnnalitycsEvent(videoId: Int64?, playerId: String?) {
        logAnnalitycsEvent(videoId: videoId, playerId: playerId, event: .loadedVideo)
    }
    
    func logEmbedLoadAnnalitycsEvent(videoId: Int64?, playerId: String?) {
        logAnnalitycsEvent(videoId: videoId, playerId: playerId, event: .loadedEmbed)
    }
    
    private func logAnnalitycsEvent(videoId: Int64?, playerId: String?, event: AnalyticsRequest.AnalyticsEvent) {
        guard let videoId = videoId, let playerId = playerId else {
            return
        }
        let client = APIClient()
        let request = AnalyticsRequest(embedId: embedId, videoId: String(videoId), playerId: playerId, hrefKey: hrefKey, event: event)
        
        client.requestData(request: request) { _ in }
    }
}
