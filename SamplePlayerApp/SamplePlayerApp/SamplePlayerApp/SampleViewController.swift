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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createOOvvuuPlayerView()
    }
    
    private func createOOvvuuPlayerView() {
        let oovvuuView = OovvuuPlayer.getSinglePlayerView(config: OovvuuConfig())
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

