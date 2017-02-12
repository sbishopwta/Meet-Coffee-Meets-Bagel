//
//  MemberDetailViewController.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import Foundation
import UIKit
import os

class MemberDetailViewController: UIViewController, ARNImageTransitionZoomable {
    
    private let teamMember: TeamMember
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15.0
        stackView.axis = .vertical
        return stackView
    }()
    
    var imageView = UIImageView()
    
    init(teamMember: TeamMember) {
        self.teamMember = teamMember
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
    
    //MARK - Setup
    
    private func setup() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        view.backgroundColor = Theme.Colors.coffeeGray()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        loadImage(with: teamMember.avatarUrl, into: imageView)
        loadImage(with: teamMember.avatarUrl, into: imageView) { [weak self] (result, usesCache) in
            guard let strongSelf = self else {
                os_log("self was nil in %@", type: .error, #function)
                return
            }
            if let image = result.value {
                strongSelf.imageView.image = image
            } else {
                strongSelf.imageView.image = ImageUtilities.getPlaceholderImage(for: strongSelf.teamMember.id)
            }
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Theme.Metrics.CornerRadius.imageView
        scrollView.addSubview(imageView)
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "\(teamMember.firstName) \(teamMember.lastName)".uppercased()
        nameLabel.font = UIFont.semiBoldFontOfSize(size: 16.0)
        stackView.addArrangedSubview(nameLabel)
        
        let jobTitleLabel = UILabel()
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        jobTitleLabel.text = teamMember.jobTitle
        jobTitleLabel.font = UIFont.semiBoldFontOfSize(size: 14.0)
        stackView.addArrangedSubview(jobTitleLabel)
        
        let bioLabel = UILabel()
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.numberOfLines = 0
        bioLabel.text = teamMember.bio
        bioLabel.font = UIFont.primaryFontOfSize(size: 14.0)
        stackView.addArrangedSubview(bioLabel)
    }
    
    private func setupConstraints() {
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        //TODO: Handle resize on rotation
        let imageViewWidth = view.bounds.width - 15.0
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 13.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 13.0).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15.0).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 6.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12.0).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    //MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.imageView.image)
        imageView.contentMode = self.imageView.contentMode
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Theme.Metrics.CornerRadius.imageView
        imageView.isUserInteractionEnabled = false
        var imageViewFrame = self.imageView.frame
        imageViewFrame.origin.y += topLayoutGuide.length
        imageView.frame = imageViewFrame
        return imageView
    }
    
    func presentationBeforeAction() {
        imageView.isHidden = true
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        imageView.isHidden = false
    }
    
    func dismissalBeforeAction() {
        imageView.isHidden = true
    }
}
