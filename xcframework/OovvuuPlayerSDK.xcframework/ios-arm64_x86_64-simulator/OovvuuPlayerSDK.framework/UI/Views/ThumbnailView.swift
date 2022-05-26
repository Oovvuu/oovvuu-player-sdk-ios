//
//  ThumbnailView.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 9/4/2022.
//

import Foundation
import UIKit

class ThumbnailView: UIView {
    let url: URL
    var imageView: UIImageView
    
    init(url: URL) {
        self.url = url
        self.imageView = UIImageView(frame: CGRect.zero)
        super.init(frame: CGRect.zero)
        configureView()
        loadImage(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}
