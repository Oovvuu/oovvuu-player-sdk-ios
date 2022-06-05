//
//  SampleViewController.swift
//  OovvuuSDK
//
//  Created by Alex Nazarov on 16/5/2022.
//

import Combine
import UIKit
import OovvuuPlayerSDK

class SampleViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    private let hrefKey = "Please_use_your_href_key"
    private let appId = "Please_use_your_appId_key"
    private let embedId = "Please_use_your_embedId_key"
    private let apiKey = "Please_use_your_apiKey_key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createOOvvuuPlayerView()
    }
    
    private func createOOvvuuPlayerView() {
        let config = OovvuuConfig(
            hrefKey: hrefKey,
            appId: appId,
            embedId: embedId,
            apiKey: apiKey)
        let oovvuuView = OovvuuPlayer.getSinglePlayerView(config: config)
        oovvuuView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(oovvuuView)
        NSLayoutConstraint.activate([
            oovvuuView.topAnchor.constraint(equalTo: contentView.topAnchor),
            oovvuuView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            oovvuuView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            oovvuuView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

