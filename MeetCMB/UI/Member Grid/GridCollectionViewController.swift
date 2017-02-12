//
//  ViewController.swift
//  MeetCMB
//
//  Created by Steven Bishop on 2/5/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

import UIKit
import os

fileprivate extension Selector {
    static let sortTapped =
        #selector(GridCollectionViewController.sortButtonTapped(sender:))
}

class GridCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching, ARNImageTransitionZoomable {
    
    var teamMembers = APIService.parseTeam()
    private weak var selectedImageView : UIImageView?
    
    convenience init() {
        self.init(collectionViewLayout:  UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sort").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: .sortTapped)
    }
    
    private func setupCollectionView() {
        
        guard let collectionView = collectionView else {
            os_log("Unable to setup collectionView. CollectionView was nil in : %@", type: .error, #function)
            return
        }
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            os_log("Unable to assign flowLayout as a UICollectionViewFlowLayout", type: .error)
            return
        }
        
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.reusableIdentifier)
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = Theme.Colors.coffeeGray()
        
        flowLayout.sectionInset.left = Theme.Metrics.EdgeInsets.collectionViewInsets.left
        flowLayout.sectionInset.right = Theme.Metrics.EdgeInsets.collectionViewInsets.right
        flowLayout.sectionInset.top = Theme.Metrics.EdgeInsets.collectionViewInsets.top
        flowLayout.sectionInset.bottom = Theme.Metrics.EdgeInsets.collectionViewInsets.bottom
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let contentWidth = (collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)
        flowLayout.itemSize = CGSize(width: contentWidth/3, height: contentWidth/3)
    }
    
    //MARK - Sorting
    
    func sortButtonTapped(sender: UIBarButtonItem)  {
        
        let sortAlertController = SortAlertController(dataSource: teamMembers) { [weak self] (sortedTeamMembers) in
            guard let strongSelf = self else {
                os_log("self was nil in %@", type: .error, #function)
                return
            }
            strongSelf.teamMembers = sortedTeamMembers
            strongSelf.collectionView!.reloadItems(at: strongSelf.collectionView!.indexPathsForVisibleItems)
        }
        
        sortAlertController.popoverPresentationController?.barButtonItem = sender
        sortAlertController.popoverPresentationController?.permittedArrowDirections = .any
        navigationController?.present(sortAlertController, animated: true, completion: nil)
    }
    
    //MARK - UICollectionViewDataSourcePrefetching
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let teamMember = teamMembers[indexPath.item]
            ImageManager.shared.loadImage(with: teamMember.avatarUrl, token: nil) { (result) in }
        }
    }
    
    //MARK - UICollectionViewDatasource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamMembers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.reusableIdentifier, for: indexPath) as! GridCollectionViewCell
        let teamMember = teamMembers[indexPath.item]
        cell.configure(teamMember: teamMember)
        
        return cell
    }
    
    //MARK - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let teamMember = teamMembers[indexPath.item]
        navigationController?.navigationBar.tintColor = Theme.getBarTintColor(for: teamMember)
        let detailViewController = MemberDetailViewController(teamMember: teamMember)
        let cell = collectionView.cellForItem(at: indexPath) as! GridCollectionViewCell
        self.selectedImageView = cell.avatarImageView
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    //MARK - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        guard let selectedImageView = selectedImageView else {
            os_log("SelectedImageView was nil when transitioning view controllers in %@. This should never happen.", type: .fault, #function)
            return UIImageView()
        }
        
        let imageView = UIImageView(image: selectedImageView.image)
        imageView.contentMode = selectedImageView.contentMode
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Theme.Metrics.CornerRadius.imageView
        imageView.isUserInteractionEnabled = false
        imageView.frame = selectedImageView.convert(selectedImageView.bounds, to: view)
        
        return imageView
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        selectedImageView?.isHidden = true
    }
    
    func dismissalCompletionAction(_ completeTransition: Bool) {
        selectedImageView?.isHidden = false
    }
}

fileprivate class SortAlertController: UIAlertController {
    
    private let handler: ([TeamMember]) -> Void
    private let teamMembers: [TeamMember]
    
    init(dataSource: [TeamMember], handler: @escaping (([TeamMember]) -> Void)) {
        self.handler = handler
        self.teamMembers = dataSource
        
        super.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Sort Options", comment: "SortAlertController.Title")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    //TODO: If sort has been applied, don't show it as an option
    private func setupActions()  {
        let firstName = NSLocalizedString("First Name", comment: "SortAlertController.FirstName")
        let firstNameAction = UIAlertAction(title: firstName, style: .default) { [weak self] (action) in
            
            guard let strongSelf = self else {
                os_log("self was nil in %@", type: .error, #function)
                return
            }
            
            let sortedByFirstName = strongSelf.teamMembers.sorted { $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == ComparisonResult.orderedAscending }
            strongSelf.handler(sortedByFirstName)
        }
        addAction(firstNameAction)
        
        let lastName = NSLocalizedString("Last Name", comment: "SortAlertController.LastName")
        let lastNameAction = UIAlertAction(title: lastName, style: .default) { [weak self] (action) in
            guard let strongSelf = self else {
                os_log("self was nil in %@", type: .error, #function)
                return
            }
            let sortedByLastName = strongSelf.teamMembers.sorted { $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == ComparisonResult.orderedAscending }
            strongSelf.handler(sortedByLastName)
        }
        addAction(lastNameAction)
        
        let cancelTitle = NSLocalizedString("Cancel", comment: "SortAlertController.Cancel")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive, handler: nil)
        addAction(cancelAction)
    }
}
