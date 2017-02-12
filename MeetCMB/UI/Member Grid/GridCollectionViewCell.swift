//
//  GridCollectionViewCell.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import Foundation
import UIKit
import os

class GridCollectionViewCell: UICollectionViewCell {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(avatarImageView)
        avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7.0).isActive = true
        avatarImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7.0).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.0).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7.0).isActive = true
        
        avatarImageView.layer.cornerRadius = Theme.Metrics.CornerRadius.imageView
        
        contentView.addSubview(moreImageView)
        moreImageView.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: -5.0).isActive = true
        moreImageView.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 5.0).isActive = true
        moreImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        moreImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func configure(teamMember: TeamMember) {
        
        avatarImageView.image = ImageUtilities.getPlaceholderImage(for: teamMember.id)
        moreImageView.image = ImageUtilities.getMoreButton(for: teamMember.id)

        let urlRequest = URLRequest(url: teamMember.avatarUrl)
        var request = Request(urlRequest: urlRequest)
        request.process(with: PhotoEffectNoir(identifier: teamMember.id))
        
        loadImage(with: request, into: avatarImageView) { [weak self] (result, isFromMemoryCache) in
            guard let strongSelf = self else {
                os_log("self was nil in %@. Unable to load image.", type: .error, #function)
                return
            }
            if let image = result.value {
                strongSelf.avatarImageView.image = image
            }
            
            strongSelf.activityIndicatorView.stopAnimating()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        activityIndicatorView.startAnimating()
    }
}

struct PhotoEffectNoir: Processing {
    private let identifier: Int
    
    ///Identifier for cache
    init(identifier: Int) {
        self.identifier = identifier
    }
    
    func process(_ image: Image) -> Image? {
        return image.applyFilter(filter: CIFilter(name: "CIPhotoEffectNoir"))
    }
    
    static func == (lhs: PhotoEffectNoir, rhs: PhotoEffectNoir) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
