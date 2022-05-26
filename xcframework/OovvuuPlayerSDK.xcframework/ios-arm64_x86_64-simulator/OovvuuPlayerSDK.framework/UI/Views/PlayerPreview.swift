//
//  PlayerPreview.swift
//  OovvuuSDK
//
//  Created by Sergey Klimusha on 9/4/2022.
//

import Foundation
import UIKit

class PlayerPreview: UIView {
    let video: Video
    let logoDimentions: Double = 40
    let playIconDimentions: Double = 32
    let textViewSIze: Double = 24
    let titleViewSize: Double = 44
    let titleFontSize: Double = 14
    let fontSize: Double = 12
    let margin: Double = 8
    let noMargin: Double = 0
    let textTopMargin: Double = 3
    
    let thumbnailView: ThumbnailView
    let dimmedLayer: UIView
    let publishedAtView: UITextView
    let durationView: UITextView
    let titleView: UITextView
    let logoView: ThumbnailView
    let playIcon: UIImageView
    let action: () -> Void
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .white
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        return view
    }()
    
    init(video: Video, action: @escaping () -> Void) {
        self.video = video
        self.action = action
        
        //Init views
        self.thumbnailView = ThumbnailView(url: URL(string: video.thumbnail)!)
        self.dimmedLayer = UIView(frame: CGRect.zero)
        self.publishedAtView = UITextView(frame: CGRect.zero)
        self.durationView = UITextView(frame: CGRect.zero)
        self.titleView = UITextView(frame: CGRect.zero)
        self.logoView = ThumbnailView(url: URL(string: video.provider.logoUrl)!)
        self.playIcon = UIImageView(frame: CGRect.zero)
        
        super.init(frame: CGRect.zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        guard let thumbnailURL = URL(string: video.thumbnail),
              let logoURL = URL(string: video.provider.logoUrl) else { return }
        
        addThumbnailView(url: thumbnailURL)
        addDimmedLayer()
        addPublishedAtView(publishedAt: video.publishedAt)
        addDurationView(duration: video.duration)
        addTitleView(title: video.title)
        addLogoView(url: logoURL)
        addPlayIconView()
        
        addGestureRecognizer()
    }
    
    private func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        displayLoadingIndicator()
        action()
    }
    
    private func addThumbnailView(url: URL) {
        addSubview(thumbnailView)
        
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addDimmedLayer() {
        dimmedLayer.backgroundColor = .black
        dimmedLayer.alpha = 0.43
        dimmedLayer.layer.cornerRadius = 10.0
        dimmedLayer.layer.masksToBounds = true
        
        addSubview(dimmedLayer)
        
        dimmedLayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedLayer.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor),
            dimmedLayer.trailingAnchor.constraint(equalTo: thumbnailView.trailingAnchor),
            dimmedLayer.topAnchor.constraint(equalTo: thumbnailView.topAnchor),
            dimmedLayer.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor)
        ])
    }
    
    private func addPublishedAtView(publishedAt: Date) {
        publishedAtView.textContainerInset = UIEdgeInsets(top: textTopMargin,
                                                          left: noMargin,
                                                          bottom: margin,
                                                          right: noMargin)
        publishedAtView.textContainer.lineFragmentPadding = noMargin
        publishedAtView.backgroundColor = .clear
        publishedAtView.textColor = .white
        publishedAtView.font = .systemFont(ofSize: fontSize)
        publishedAtView.isEditable = false
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: publishedAt, relativeTo: Date())
        publishedAtView.text = relativeDate
        
        addSubview(publishedAtView)
        
        publishedAtView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publishedAtView.heightAnchor.constraint(equalToConstant: textViewSIze),
            publishedAtView.widthAnchor.constraint(equalToConstant: textViewSIze * 4),
            publishedAtView.leadingAnchor.constraint(equalTo: thumbnailView.imageView.leadingAnchor, constant: margin),
            publishedAtView.bottomAnchor.constraint(equalTo: thumbnailView.imageView.bottomAnchor)
        ])
    }
    
    private func addDurationView(duration: Int64) {
        durationView.textContainerInset = UIEdgeInsets(top: textTopMargin,
                                                       left: noMargin,
                                                       bottom: margin,
                                                       right: noMargin)
        durationView.textContainer.lineFragmentPadding = noMargin
        durationView.backgroundColor = .clear
        durationView.textColor = .white
        durationView.font = .boldSystemFont(ofSize: fontSize)
        durationView.textAlignment = .right
        durationView.isEditable = false
        durationView.text = convertTime(time: TimeInterval(duration))

        addSubview(durationView)
        
        durationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            durationView.heightAnchor.constraint(equalToConstant: textViewSIze),
            durationView.widthAnchor.constraint(equalToConstant: textViewSIze * 4),
            durationView.trailingAnchor.constraint(equalTo: thumbnailView.imageView.trailingAnchor, constant: -margin),
            durationView.bottomAnchor.constraint(equalTo: thumbnailView.imageView.bottomAnchor)
        ])
    }
    
    private func addTitleView(title: String) {
        titleView.textContainerInset = UIEdgeInsets(top: textTopMargin,
                                                    left: noMargin,
                                                    bottom: margin,
                                                    right: noMargin)
        titleView.textContainer.lineFragmentPadding = noMargin
        titleView.backgroundColor = .clear
        titleView.textColor = .white
        titleView.font = .systemFont(ofSize: titleFontSize)
        titleView.textAlignment = .left
        titleView.textContainer.maximumNumberOfLines = 2
        titleView.isEditable = false
        titleView.text = title
        
        addSubview(titleView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: thumbnailView.imageView.leadingAnchor, constant: margin),
            titleView.trailingAnchor.constraint(equalTo: thumbnailView.imageView.trailingAnchor, constant: -margin),
            titleView.heightAnchor.constraint(lessThanOrEqualToConstant: titleViewSize),
            titleView.bottomAnchor.constraint(equalTo: publishedAtView.topAnchor, constant: -margin)
        ])
    }
    
    private func addLogoView(url: URL) {
        addSubview(logoView)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalToConstant: logoDimentions),
            logoView.widthAnchor.constraint(equalToConstant: logoDimentions),
            logoView.leadingAnchor.constraint(equalTo: thumbnailView.imageView.leadingAnchor, constant: margin),
            logoView.bottomAnchor.constraint(equalTo: titleView.topAnchor, constant: -textTopMargin)
        ])
    }
    
    private func addPlayIconView() {
        playIcon.image = #imageLiteral(resourceName: "playIcon.png")
        
        addSubview(playIcon)
        
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playIcon.heightAnchor.constraint(equalToConstant: playIconDimentions),
            playIcon.widthAnchor.constraint(equalToConstant: playIconDimentions),
            playIcon.centerXAnchor.constraint(equalTo: thumbnailView.imageView.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: thumbnailView.imageView.centerYAnchor)
        ])
    }
    
    private func displayLoadingIndicator() {
        playIcon.removeFromSuperview()
        addSubview(loadingIndicatorView)
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func convertTime(time: TimeInterval) -> String {
        let timeInSeconds = time / 1000
        let hour = Int(timeInSeconds) / 3600
        let minute = Int(timeInSeconds) / 60 % 60
        let second = Int(timeInSeconds) % 60

        // return formated string
        if (hour == 0) {
            return String(format: "%02i:%02i", minute, second)
        }
        
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
}
