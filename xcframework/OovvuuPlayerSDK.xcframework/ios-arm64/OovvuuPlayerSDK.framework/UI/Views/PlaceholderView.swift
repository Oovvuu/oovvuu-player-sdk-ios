//
//  PlaceholderView.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 13/4/2022.
//

import UIKit

class PlaceholderView: UIView {
    let imageName: String
    var imageView: UIImageView
    let margin: Double = 20
    let imageHeight: Double = 32.5
    let backgroundAlpha: Double = 0.74
    let backgroundColorInt: Int = 0xF0F0F0
    
    init(imageName: String = "placeholderImage") {
        self.imageName = imageName
        self.imageView = UIImageView(frame: CGRect.zero)
        super.init(frame: CGRect.zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = UIColor(rgb: backgroundColorInt)
        alpha = backgroundAlpha
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: imageName)
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageHeight),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -margin)
        ])
    }
}
