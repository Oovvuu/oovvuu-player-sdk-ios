//
//  ViewController.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 6/4/2022.
//

import UIKit
import BrightcovePlayerSDK
import BrightcoveIMA
import GoogleInteractiveMediaAds
import AVKit
import Combine

class SinglePlayerViewController: UIViewController {
        
    private let manager: BCOVPlayerSDKManager = BCOVPlayerSDKManager.shared()
    private let avpvc: AVPlayerViewController = AVPlayerViewController()

    var playbackController: BCOVPlaybackController?
    
    var subscriptions: Set<AnyCancellable> = []
    
    lazy var placeHolderView: PlaceholderView = {
        PlaceholderView()
    }()
    
    let config: OovvuuConfig
    
    lazy var viewModel: PlayerViewModel = {
        return PlayerViewModel(
            appId: config.appId,
            embedId: config.embedId,
            apiKey: config.apiKey,
            hrefKey: config.hrefKey
        )
    }()
    
    let previewContainerView = UIView()
    let playerContainerView = UIView()
    
    let containerHeight: Double = 200
    let aspectRatio: Double = 171 / 304
    let margin: Double = 8
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(config: OovvuuConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)

        subscribeToPlayerState()
        viewModel.requestData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    private func subscribeToPlayerState() {
        viewModel
            .$state
            .sink { state in
                switch state {
                case .loading:
                    self.setupUpContainerView()
                case .success(_):
                    self.setupPlayerView()
                case .error(_):
                    break
                }
            }
            .store(in: &subscriptions)
        
        NotificationCenter
            .Publisher(center: .default,
                       name: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.resumeAdAfterForeground()
            }
            .store(in: &subscriptions)
    }
    
    private func setupPlayerView() {
        DispatchQueue.main.async {
            self.placeHolderView.removeFromSuperview()
            self.addPlayerPreview() { [unowned self] in
                handlePlayButtonAction()
            }
        }
    }
    
    private func handlePlayButtonAction() {
        configurePresentation()
        setup(
            accountID: viewModel.brightcove?.accountId,
            videoPublisherID: viewModel.video?.provider.id,
            policyKey: nil
        )
        viewModel.requestContentFromPlaybackService(
            videoID: viewModel.video?.brightcoveVideoId,
            adTag: viewModel.video?.adTag,
            viewRect: view.bounds,
            authToken: viewModel.brightcove?.authToken,
            onCompletion: { [weak self] videos in
                self?.playbackController?.setVideos(videos as NSFastEnumeration)
            }
        )
    
        viewModel.logPlayAnnalitycsEvent(videoId: viewModel.video?.id, playerId: viewModel.brightcove?.playerId)
    }
    
    // MARK: - Setup UI
    
    private func addPlayerPreview(action: @escaping () -> Void) {
        guard let video = viewModel.video else {
            return
        }
        let playerPreview = PlayerPreview(video: video, action: action)
        previewContainerView.addSubview(playerPreview)
        playerPreview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerPreview.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            playerPreview.rightAnchor.constraint(equalTo: previewContainerView.rightAnchor),
            playerPreview.leftAnchor.constraint(equalTo: previewContainerView.leftAnchor),
            playerPreview.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor)
        ])
    }
    
    private func setupUpContainerView() {
        
        //contentView.addSubview(previewContainerView)
        view.addSubview(previewContainerView)
        
        previewContainerView.layer.cornerRadius = margin
        previewContainerView.layer.masksToBounds = true
        previewContainerView.translatesAutoresizingMaskIntoConstraints = false
        previewContainerView.layer.zPosition = 1
        NSLayoutConstraint.activate([
            previewContainerView.heightAnchor.constraint(equalTo: previewContainerView.widthAnchor, multiplier: aspectRatio),
            previewContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            previewContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            previewContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            previewContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            previewContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: containerHeight)
        ])
        
        displayPlaceHolderView()
    }
    
    private func displayPlaceHolderView() {
        previewContainerView.addSubview(placeHolderView)
        placeHolderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderView.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            placeHolderView.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor),
            placeHolderView.rightAnchor.constraint(equalTo: previewContainerView.rightAnchor),
            placeHolderView.leftAnchor.constraint(equalTo: previewContainerView.leftAnchor)
        ])
    }
    
    private func configurePresentation() {
//        contentView.addSubview(playerContainerView)
       view.addSubview(playerContainerView)
        
        playerContainerView.layer.cornerRadius = margin
        playerContainerView.layer.masksToBounds = true
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false
        playerContainerView.layer.zPosition = 0
        NSLayoutConstraint.activate([
            playerContainerView.heightAnchor.constraint(equalTo: playerContainerView.widthAnchor, multiplier: aspectRatio),
            playerContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            playerContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            playerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            playerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            playerContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: containerHeight)
        ])
        
        playerContainerView.addSubview(avpvc.view)
        avpvc.view.layer.cornerRadius = margin
        avpvc.view.layer.masksToBounds = true
        avpvc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avpvc.view.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
            avpvc.view.rightAnchor.constraint(equalTo: playerContainerView.rightAnchor),
            avpvc.view.leftAnchor.constraint(equalTo: playerContainerView.leftAnchor),
            avpvc.view.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor)
        ])
    }
    
    private func displayPlayer() {
        DispatchQueue.main.async {
            self.playerContainerView.layer.zPosition = 2
        }
    }

    // MARK: - Helper Methods
    
    private func setup(accountID: String?, videoPublisherID: Int64?, policyKey: String? = nil) {
    
        playbackController = manager.createIMAPlaybackController(with:
                                                                    viewModel.getIMASettings(videoPublisherID: videoPublisherID),
                                                                 adsRenderingSettings: viewModel.getRenderSettings(presenter: self),
                                                                 adsRequestPolicy: viewModel.getAdsRequestPolicy(),
                                                                 adContainer: playerContainerView,
                                                                 viewController: self,
                                                                 companionSlots: nil,
                                                                 viewStrategy: nil,
                                                                 options: viewModel.getIMAPlaybackSessionOptions(sessionDelegate: self)
        )
        playbackController?.delegate = self
        playbackController?.isAutoAdvance = true
        playbackController?.isAutoPlay = true

        
        // Prevents the Brightcove SDK from making an unnecessary AVPlayerLayer
        // since the AVPlayerViewController already makes one
        playbackController?.options = viewModel.getPlaybackControllerOptions()
        
        viewModel.initPlaybackService(accountId: accountID, policyKey: policyKey)
    }
}

// MARK: - BCOVPlaybackControllerDelegate

extension SinglePlayerViewController: BCOVPlaybackControllerDelegate {
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("ViewController Debug - Advanced to new session.")
        avpvc.player = session.player
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
        // Ad events are emitted by the BCOVIMA plugin through lifecycle events.
        // The events are defined BCOVIMAComponent.h.
        
        let type = lifecycleEvent.eventType
        
        if type == kBCOVIMALifecycleEventAdsLoaderLoaded {
            print("ViewController Debug - Ads loaded.")
            
            // When ads load successfully, the kBCOVIMALifecycleEventAdsLoaderLoaded lifecycle event
            // returns an NSDictionary containing a reference to the IMAAdsManager.
            guard let adsManager = lifecycleEvent.properties[kBCOVIMALifecycleEventPropertyKeyAdsManager] as? IMAAdsManager else {
                return
            }
            
            // Lower the volume of ads by half.
            adsManager.volume = adsManager.volume / 2.0
            let volumeString = String(format: "%0.1", adsManager.volume)
            print("ViewController Debug - IMAAdsManager.volume set to \(volumeString)")
            
        } else if type == kBCOVIMALifecycleEventAdsManagerDidReceiveAdEvent {
            
            guard let adEvent = lifecycleEvent.properties["adEvent"] as? IMAAdEvent else {
                return
            }
            
            switch adEvent.type {
            case .STARTED:
                print("ViewController Debug - Ad Started.")
                displayPlayer()
                viewModel.isAdPlaying = true
            case .AD_BREAK_FETCH_ERROR:
                print("ViewController Debug - Ad Started.")
                displayPlayer()
            case .COMPLETE:
                print("ViewController Debug - Ad Completed.")
                viewModel.isAdPlaying = false
                displayPlayer()
            case .ALL_ADS_COMPLETED:
                print("ViewController Debug - All ads completed.")
            default:
                break
            }
        } else if type == kBCOVIMALifecycleEventAdsLoaderFailed {
            print("ViewController Debug - Ads load failed.")
            displayPlayer()
        }
    }
    
    private func resumeAdAfterForeground() {
        if viewModel.isAdPlaying == true && viewModel.isBrowserOpen == false {
            playbackController?.resumeAd()
        }
    }
}

extension SinglePlayerViewController: BCOVPlaybackControllerAdsDelegate {
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, ad: BCOVAd!, didProgressTo progress: TimeInterval) {
        
        let imaAd = ad.properties[kBCOVIMAAdPropertiesKeyIMAAdInstance] as? IMAAd
        let duration = imaAd?.duration as? TimeInterval
        print("Progress: \(progress)| Duration: \(String(describing: duration))")
    }
}

extension SinglePlayerViewController: IMALinkOpenerDelegate {
    
    func linkOpenerDidClose(inAppLink linkOpener: NSObject!) {
        // Called when the in-app browser has closed.
        playbackController?.resumeAd()
        viewModel.isBrowserOpen = false
    }
    
    func linkOpenerDidOpen(inAppLink linkOpener: NSObject!) {
        viewModel.isBrowserOpen = true
    }
    
}
